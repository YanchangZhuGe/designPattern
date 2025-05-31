<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.util.AppCrypt" %> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
  
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = df.format(new Date());
	String projectInfoNo = user.getProjectInfoNo();
	
	String optionType = request.getParameter("optionType");
 
	String projectFatherNo="";
	if(request.getParameter("projectFatherNo")!=null){
		projectFatherNo = request.getParameter("projectFatherNo");
	}
	String projectFatherName=request.getParameter("projectFatherName")==null?"":java.net.URLDecoder.decode(request.getParameter("projectFatherName"),"utf-8");
	String userName=user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />

  <title>项目维护</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	 <td class="ali_cdn_name"><b>父项目名称:</b></td>
				 <td align="left"><%=projectFatherName%></td>
			    <td>&nbsp;</td> 
			  	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="新建子项目"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{ws_detail_no}-{option_type}' id='rdo_entity_id_{ws_detail_no}'  onclick='chooseOne(this);' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{project_name}">项目名称</td>
			      <td class="bt_info_even" exp="{manage_org_name}">甲方单位</td>	
			      <td class="bt_info_odd" exp="{well_no}">井号</td>
			      <td class="bt_info_even" exp="{business_type_name}">项目业务类型</td>		
			      <td class="bt_info_odd" exp="{start_time}">项目开始时间</td>
			      <td class="bt_info_even" exp="{end_time}">项目结束时间</td>		      
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li> 
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					 <table width="100%" border="0" cellspacing="0" cellpadding="0">
		                <tr align="right" height="30">
		                  <td>&nbsp;</td>
		                  <td width="30" id="buttonDis1" ><span class="bc"  onclick="toUpdateProject()"><a href="#"></a></span></td>
		                  <td width="5"></td>
		                </tr>
		              </table>
				     <table width="100%" border="1" cellspacing="0" cellpadding="0"
							class="tab_line_height" id="Offsettable">
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>项目名称：</td>
								<td class="inquire_form4" id="item0_0">
								    <input type="hidden"
									id="ws_project_no" name="ws_project_no"
									value="<%=projectFatherNo%>" class="input_width" />
									<input type="hidden" id="ws_detail_no" name="ws_detail_no" value=""
									class="input_width" />
									
									<input type="text" id="project_name" name="project_name" value=""
									class="input_width" /></td>
								<td class="inquire_item4">项目编号：</td>
								<td class="inquire_form4" id="item0_1"><input type="text"
									id="project_id" name="project_id" value=""
									disabled="disabled" class="input_width_no_color" /></td>
							</tr>
							<tr>
							<td class="inquire_item4"><span class="red_star">*</span>井号：</td>
							<td class="inquire_form4" id="item0_9"><input type="text"
									id="well_no" name="well_no" value=""
									class="input_width" /></td>
							 <td class="inquire_item4">项目类型：</td>
								<td class="inquire_form4" id="item0_2"><input type="hidden"
									id="project_type" name="project_type" value="5000100004000000008"
									class="input_width" /> <select class=select_width
									name="project_type_name" id="project_type_name"
									disabled="disabled">
										<option value='5000100004000000008'>井中地震</option>
								</select></td>
							</tr>
							<tr> 
								<td class="inquire_item4">年度：</td>
								<td class="inquire_form4" id="item0_5">
								<input type="text"
									id="project_year" name="project_year" value=""
									class="input_width_no_color" readonly="readonly"/> 
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>项目重要程度：</td>
								<td class="inquire_form4" id="item0_8">
									<select name="is_main_project" id="is_main_project" class="select_width">
										<option value="">--请选择--</option>
										<option value="1">集团重点</option>
										<option value="2">地区（局）重点</option>
										<option value="3" selected="selected">正常</option>
									</select>

								</td>
							</tr>
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>项目开始时间：</td>
								<td class="inquire_form4" id="item0_6"><input type="text"
									id="start_time" name="start_time" value=""
									class="input_width" readonly="readonly" /> &nbsp;&nbsp;<img
									src="<%=contextPath%>/images/calendar.gif" id="tributton1"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(start_time,tributton1);" />
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>项目结束时间：</td>
								<td class="inquire_form4" id="item0_7"><input type="text"
									id="end_time" name="end_time" value=""
									class="input_width" readonly="readonly" /> &nbsp;&nbsp;<img
									src="<%=contextPath%>/images/calendar.gif" id="tributton2"
									width="16" height="16" style="cursor: hand;"
									onmouseover="calDateSelector(end_time,tributton2);" />
								</td>
							</tr>
						 
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>国内/国外：</td>
								<td class="inquire_form4" id="item0_12"><select
									class=select_width name=project_country id="project_country">
										<option value="1">国内</option>
										<option value="2">国外</option>
								</select></td>
								<td class="inquire_item4"><span class="red_star">*</span>甲方单位：</td>
								<td class="inquire_form4" id="item0_13"><input
									id="manage_org" name="manage_org" value="" type="hidden"
									class="input_width" /> <input id="manage_org_name"
									name="manage_org_name" value="" type="text" class="input_width"
									readonly="readonly" /> &nbsp;&nbsp;<img
									src="<%=request.getContextPath()%>/images/magnifier.gif"
									style="cursor: hand;" border="0"
									onclick="selectManageOrgCode('manage_org','manage_org_name');" />
								</td>
							</tr>
							<tr>
							<td class="inquire_item4"><span class="red_star">*</span>利润中心：</td>
								<td class="inquire_form4" id="item0_18">
								<input type="hidden" id="prctr" name="prctr" value="G0150100" class="input_width" />
								<input type="text" id="prctr_name" name="prctr_name" value="新兴物探开发处" class="input_width_no_color" readonly="readonly" /> &nbsp;&nbsp;
								</td>
								<td class="inquire_item4"><span class="red_star">*</span>项目业务类型：</td>
								<td class="inquire_form4" id="item0_17">
								<select
									class=select_width name=project_business_type id="project_business_type"> 
										<option value="">--请选择--</option>
										<option value="1">处理</option>
										<option value="2">解释</option>
										<option value="3">处理,解释</option>
								</select>
								 
								</td>
							</tr>
							 
						</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				 <iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>		
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
cruConfig.cdtType = 'form';
	
	function refreshData(){  
		cruConfig.queryStr = "  select t.* from ( select  rownum,ccsd.coding_name as manage_org_name,decode(pdt.project_type,'5000100004000000008','井中地震')project_type_name,decode(pdt.project_country,'1','国内','2','国外')project_country_name,decode(pdt.is_main_project,'1','集团重点','2','地区（局）重点','3','正常')is_main_name,decode(pdt.project_business_type,'1','处理','2','解释','3','处理,解释') business_type_name, pdt.ws_detail_no ,pdt.ws_project_no,pdt.project_name,pdt.project_id,pdt.project_year,pdt.project_type,pdt.market_classify,pdt.well_no,pdt.option_type,pdt.start_time,pdt.end_time,pdt.is_main_project,pdt.project_country,pdt.manage_org,pdt.prctr,pdt.prctr_name,pdt.project_business_type  from  GP_WS_PROJECT_DETAIL pdt  left join comm_coding_sort_detail ccsd on pdt.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0'   where pdt.bsflag='0' and pdt.option_type='<%=optionType%>' and pdt.ws_project_no='<%=projectFatherNo%>' order by pdt.modifi_date desc ) t   ";
		cruConfig.currentPageUrl = "/td/vspExplain/vspProject/subProjectList.jsp";
		queryData(1);
	}

 
    function loadDataDetail(ids){
    	 
   	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
 
		var querySql = "   select  rownum,ccsd.coding_name as manage_org_name,decode(pdt.project_type,'5000100004000000008','井中地震')project_type_name,decode(pdt.project_country,'1','国内','2','国外')project_country_name,decode(pdt.is_main_project,'1','集团重点','2','地区（局）重点','3','正常')is_main_name,decode(pdt.project_business_type,'1','处理','2','解释','3','处理,解释') business_type_name, pdt.ws_detail_no ,pdt.ws_project_no,pdt.project_name,pdt.project_id,pdt.project_year,pdt.project_type,pdt.market_classify,pdt.well_no,pdt.option_type,pdt.start_time,pdt.end_time,pdt.is_main_project,pdt.project_country,pdt.manage_org,pdt.prctr,pdt.prctr_name,pdt.project_business_type  from  GP_WS_PROJECT_DETAIL pdt  left join comm_coding_sort_detail ccsd on pdt.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0'   where pdt.bsflag='0' and pdt.option_type='<%=optionType%>' and pdt.ws_detail_no='"+ids.split("-")[0]+"' ";				 	 
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			var datas = queryRet.datas;
			if(datas != null){		  
			     document.getElementsByName("ws_detail_no")[0].value=datas[0].ws_detail_no;    
 
				 document.getElementsByName("project_name")[0].value=datas[0].project_name;  
				 document.getElementsByName("project_year")[0].value=datas[0].project_year;  
				 document.getElementsByName("well_no")[0].value=datas[0].well_no;  
				 document.getElementsByName("is_main_project")[0].value=datas[0].is_main_project;  					
				 document.getElementsByName("start_time")[0].value=datas[0].start_time;  
				 document.getElementsByName("end_time")[0].value=datas[0].end_time;  
				 document.getElementsByName("project_country")[0].value=datas[0].project_country;  
				 document.getElementsByName("manage_org")[0].value=datas[0].manage_org;  
				 document.getElementsByName("manage_org_name")[0].value=datas[0].manage_org_name;  
				  document.getElementsByName("prctr")[0].value=datas[0].prctr;  
				  document.getElementsByName("prctr_name")[0].value=datas[0].prctr_name;  
				  document.getElementsByName("project_business_type")[0].value=datas[0].project_business_type;  
				 
			}					
			
 		}	

    }
    
 
    function toAdd(){  
    	
		var projectFatherName=encodeURI(encodeURI('<%=projectFatherName%>'));
		window.location = '<%=contextPath%>/td/vspExplain/vspProject/addSubProject.jsp?projectFatherName='+projectFatherName+'&projectFatherNo=<%=projectFatherNo%>&optionType=<%=optionType%>';
 
 
    }
    
    function selectManageOrgCode(objId,objName){
    	var teamInfo = {
    		fkValue:"",
    		value:""
    	};
    	window.showModalDialog('<%=contextPath%>/common/selectManageOrg.jsp',teamInfo,'dialogWidth=600px;dialogHeight=600px');
    	if(teamInfo.fkValue!=""){
    		document.getElementById(objId).value = teamInfo.fkValue;
    		document.getElementById(objName).value = teamInfo.value;
        }
    }
    
    function getTab3(index) {  
		var	selectedTag = document.getElementById("tag3_"+index);
    	var selectedTabBox = document.getElementById("tab_box_content"+index)
    	selectedTag.className ="selectTag";
    	selectedTabBox.style.display="block";
    	
    	if(index =='1'){ 
        	var selectedTagB = document.getElementById("tag3_0");
        	var selectedTabBoxB = document.getElementById("tab_box_content0")
        	selectedTagB.className ="";
        	selectedTabBoxB.style.display="none";
    		
    	}else{ 
    		var selectedTagB = document.getElementById("tag3_1");
        	var selectedTabBoxB = document.getElementById("tab_box_content1")
        	selectedTagB.className ="";
        	selectedTabBoxB.style.display="none";
    	}

  
    }
    
    function checkForm(){
    	 
		var project_name = document.getElementById("project_name").value;
		if(project_name.length==0){
			alert("项目名不能为空");
			return false;
		}
		 
		
		var well_no = document.getElementById("well_no").value;
		if(well_no.length==0){
			alert("井号不能为空");
			return false;
		}
		
		
		var start_time = document.getElementById("start_time").value;
		if(start_time.length==0){
			alert("项目开始时间不能为空");
			return false;
		}
		
		var end_time = document.getElementById("end_time").value;
		if(end_time.length==0){
			alert("项目结束时间不能为空");
			return false;
		}
		
		var manage_org = document.getElementById("manage_org").value;
		if(manage_org.length==0){
			alert("甲方单位不能为空");
			return false;
		} 
		
		return true;
	}
	
	
	function toUpdateProject(){ 
		ids = getSelectedValue();
		if (ids == '' ) {
			alert("请选择一条记录!");
			return;
		} 
 
		if (!checkForm()) return; 
		var rowParams = new Array(); 
			var rowParam = {};		
			var   ws_detail_no= ids.split("-")[0]; 
			var   project_name= document.getElementsByName("project_name")[0].value;
			var   project_type= document.getElementsByName("project_type")[0].value; 
			var   project_year= document.getElementsByName("project_year")[0].value; 
			var   well_no= document.getElementsByName("well_no")[0].value; 
			var   is_main_project= document.getElementsByName("is_main_project")[0].value; 
			var   start_time= document.getElementsByName("start_time")[0].value;
			var   end_time= document.getElementsByName("end_time")[0].value;
			var   project_country= document.getElementsByName("project_country")[0].value;
			var   manage_org= document.getElementsByName("manage_org")[0].value;
			var   prctr= document.getElementsByName("prctr")[0].value;
			var   prctr_name= document.getElementsByName("prctr_name")[0].value;
			var   project_business_type= document.getElementsByName("project_business_type")[0].value;
			 
			 rowParam['ws_project_no'] = '<%=projectFatherNo%>';
			 rowParam['project_name'] = encodeURI(encodeURI(project_name));
			 rowParam['project_type'] = encodeURI(encodeURI(project_type));
			 rowParam['project_year'] = encodeURI(encodeURI(project_year));
			 
			 rowParam['well_no'] = well_no;
			 rowParam['is_main_project'] = is_main_project;
			 rowParam['start_time'] = start_time;
			 rowParam['end_time'] = end_time;
			 rowParam['project_country'] = project_country;
			 rowParam['manage_org'] = manage_org;
			 rowParam['prctr'] = prctr;
			 rowParam['prctr_name'] = encodeURI(encodeURI(prctr_name));
			 rowParam['project_business_type'] = project_business_type; 
			 rowParam['option_type'] = '<%=optionType%>';
		  
			 if(ws_detail_no !=null && ws_detail_no !=''){
				    rowParam['ws_detail_no'] = ws_detail_no; 
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		 
					rowParam['bsflag'] = '0';
					 
			  }  				 
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	   
				saveFunc("GP_WS_PROJECT_DETAIL",rows);	
				refreshData();
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
	function toDelete(){
		var optionTypes='<%=optionType%>'; 
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	

		var querySql="";
		if(optionTypes =='vsp'){
			 // 是否关联处理解释任务书
	        querySql= " select project_info_no from GP_WS_VSP_COMMITMENTS   where  doc_type = '0110000061200000001'  and bsflag='0'  and project_info_no  in (select ws_detail_no  from GP_WS_PROJECT_DETAIL where  ws_detail_no='"+ids.split("-")[0]+"' and bsflag='0')   ";
		 
		}else {
		    querySql= " select project_info_no from GP_WS_VSP_COMMITMENTS   where  doc_type = '0110000061200000006'  and bsflag='0'  and project_info_no  in (select ws_detail_no  from GP_WS_PROJECT_DETAIL where  ws_detail_no='"+ids.split("-")[0]+"' and bsflag='0')   ";
			 
		}
      	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
        if(datas.length>0){
        	alert('子项目已在处理解释任务书中创建,不能删除');
        	return;
        }
		
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
 
		
		var sql = "update GP_WS_PROJECT_DETAIL t set t.bsflag='1' where t.ws_detail_no ='"+ids.split("-")[0]+"' ";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		refreshData();
		
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