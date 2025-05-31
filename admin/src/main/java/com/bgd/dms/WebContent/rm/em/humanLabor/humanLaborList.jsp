<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
 
 
String orgSubId = request.getParameter("orgSubId");
if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getOrgSubjectionId();
%>
<html>
<head> 
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
 <link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/style.css" /> 
 <script type="text/javascript" src="<%=contextPath %>/js/json.js"></script> 
 <script type="text/javascript" src="<%=contextPath %>/js/jquery-1.7.1.min.js"></script> 
 <script type="text/javascript" src="<%=contextPath %>/js/dialog_open.js"></script> 
 <script type="text/javascript" src="<%=contextPath %>/js/table.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/rt/rt_list.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/cn/rt_list_lan.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/rt/rt_base.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/rt/rt_validate.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/rt/rt_search.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/cn/rt_search_var.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/cute/rt_list_new.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/cn/updateListTable.js"></script>
 <script type="text/javascript" src="<%=contextPath %>/js/cute/kdy_search.js"></script>
 <script type="text/javascript">
  
  var pageTitle = "临时工信息"; cruConfig.contextPath = "<%=contextPath %>";   var genderOps = new Array( ['0','女'],['1','男']); var nationOps = new Array( ['01','锟斤拷'],['02','锟斤拷'],['03','锟斤拷'],['04','锟斤拷'],['05','壮'],['05','维'],['99','锟斤拷锟斤拷'] ); var degreeOps = new Array( ['0','锟斤拷锟斤拷'],['1','硕士'],['2','锟斤拷士'],['3','锟斤拷锟斤拷'] ); var jcdp_codes_items = null; var jcdp_codes = new Array(['employeeEducationLevel','锟侥伙拷锟教讹拷',"SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id = '0500100004' and t.bsflag = '0' order by t.coding_show_id",""]); 
  function page_init(){   var titleObj = getObj("cruTitle");  if(titleObj!=undefined) titleObj.innerHTML = pageTitle; 
  cruConfig.queryStr = " select rownum, l.labor_id, l.employee_name, l.post, l.apply_team, d3.coding_name posts, d4.coding_name apply_teams, l.employee_nation, d1.coding_name employee_nation_name, l.employee_gender, l.owning_org_id, l.owning_subjection_org_id, decode(l.employee_gender, '0', '女', '1', '男', l.employee_gender) employee_gender_name, decode(nvl(l.if_project, 0), '0', '不在项目', '1', '在项目', l.if_project) if_project_name, l.if_project, l.if_engineer, d5.coding_name if_engineer_name, l.cont_num, l.employee_birth_date, l.employee_id_code_no, l.employee_education_level, d2.coding_name employee_education_level_name, l.employee_address, l.phone_num, l.employee_health_info, l.specialty, l.elite_if, l.workerfrom,  case when lt.nu  is null then '否' else '是' end fsflag, case when lt.nu is null then '' else 'red' end bgcolor, nvl(t.years, 0) years from bgp_comm_human_labor l left join (select lt.labor_id, count(1) nu   from bgp_comm_human_labor_list lt left join  bgp_comm_human_labor l on   l.labor_id = lt.labor_id     where lt.bsflag = '0' and l.bsflag='0'   group by lt.labor_id) lt on l.labor_id = lt.labor_id  left join comm_coding_sort_detail d1 on l.employee_nation = d1.coding_code_id left join comm_coding_sort_detail d2 on l.employee_education_level = d2.coding_code_id left join comm_coding_sort_detail d3 on l.post = d3.coding_code_id left join comm_coding_sort_detail d4 on l.apply_team = d4.coding_code_id left join comm_coding_sort_detail d5 on l.if_engineer = d5.coding_code_id left join comm_org_subjection cn on l.owning_org_id = cn.org_id left join (select count(distinct to_char(t.start_date, 'yyyy')) years, t.labor_id from bgp_comm_human_labor_deploy t group by t.labor_id) t on l.labor_id = t.labor_id where l.bsflag = '0' and l.owning_subjection_org_id like '%<%=orgSubId%>%'   order by l.create_date desc";  cruConfig.currentPageUrl = "/rm/em/humanLabor/humanLaborList.lpmd";  queryData(1); } 
  function toAdd(){   popWindow("<%=contextPath%>/rm/em/humanLabor/laborModify.upmd?pagerAction=edit2Add"); }  
 
  function toEdit(){  ids = getSelIds('chx_entity_id');  if(ids==''){  alert("请选择一条信息!");  return;  }  selId = ids.split(',')[0];  editUrl = "laborModify.upmd?id={id}";  editUrl = editUrl.replace('{id}',selId);  editUrl += '&pagerAction=edit2Edit';  popWindow(editUrl); }  function toDelete(){  deleteEntities("update bgp_comm_human_labor t set t.bsflag='1',modifi_date=sysdate where t.labor_id='{id}'");   }  
  function init_down(){
		 
	  	var ids = getSelIds("chx_entity_id");
	  	if(ids==""){
	  		 ids = getObj("chx_entity_id").value;
	  	}		
		self.parent.frames["downframe"].location="<%=contextPath %>/rm/em/getLaborInfo.srq?laborId="+ids; 	  	
	}
  function blistViewLink(laborid){
	  popWindow("<%=contextPath%>/rm/em/humanLabor/laborBlistModify.upmd?id="+laborid+"&action=view");
}

 </script> 
 <title>锟叫憋拷页锟斤拷</title> 
</head> 
<body class="bgColor" onload="page_init(),init_down()">  
 <div class="dataList wrap"> 
  <div class="tt"> 
   <h2 id="cruTitle">锟斤拷锟斤拷斜锟�</h2> 
  </div> 
  <div class="ctt"> 
   <div id="buttonDiv" class="ctrlBtn"> 
    <input id="btn_add" type="button" class="btn btn_add" value=" " onclick="toAdd()" style="" /> 
    <input id="btn_edit" type="button" class="btn btn_edit" value=" " onclick="toEdit()" style="" /> 
    <input id="btn_del" type="button" class="btn btn_del" value=" " onclick="toDelete()" style="" /> 
    <input id="btn_submit" type="button" class="btn btn_submit" value=" " onclick="" style="display:none" /> 
    <input id="btn_back" type="button" class="btn btn_back" value=" " onclick="" style="display:none" /> 
    <input id="btn_close" type="button" class="btn btn_close" value=" " onclick="" style="display:none" /> 
    <input id="btn_normal" type="button" class="btn btn_normal" value=" " onclick="" style="display:none" /> 
   </div> 
   <div class="pageNumber" id="pageNumDiv"> 
    <a href="#" class="first fl"></a> 
    <a href="#" class="prev fl"></a> 
    <div class="pageNumber_cur fl" id="dataRowHint">
      锟斤拷 
     <input id="changePage" type="text" size="2" onkeydown="javascript:changePage()" /> 页 锟斤拷 5 页 
    </div> 
    <a href="#" class="next fl"></a> 
    <a href="#" class="last fl"></a> 
    <div class="clear"></div> 
   </div> 
   <!--end table_pageNumber--> 
   <!--Remark 锟斤拷询锟斤拷锟斤拷锟绞撅拷锟斤拷锟�--> 
   <div class="tableWrap"> 
    <table id="queryRetTable" class="table_list" cellpadding="0" cellspacing="0"> 
     <tr>
      <th exp="<input type='radio' name='chx_entity_id' value='{labor_id}' onclick=init_down() >">选锟斤拷</th>
      <th exp="{employee_name}">锟斤拷锟斤拷</th>
      <th exp="{employee_gender_name}">锟皆憋拷</th>
      <th exp="{employee_nation}" func="getOpValue,nationOps">锟斤拷锟斤拷</th>
      <th exp="{employee_id_code_no}">锟斤拷锟街わ拷锟�</th>
      <th exp="{employee_education_level}" func="getOpValue,degreeOps">锟侥伙拷锟教讹拷</th>
      <th exp="{cont_num}">锟酵讹拷锟斤拷同锟斤拷锟�</th>
      <th exp="{if_project_name}">锟斤拷目状态</th>
      <th exp="{apply_teams}">锟斤拷锟斤拷</th>
      <th exp="{posts}">锟斤拷位</th>
      <th exp="{years}">锟斤拷锟斤拷锟斤拷锟斤拷</th>
      <th exp="{fsflag}">锟斤拷锟斤拷</th>
     </tr>
    </table> 
   </div> 
   <!--end table_body--> 
  </div> 
  <!--end ctt--> 
 </div> 
 <!--end dataList--> 
 <script type="text/javascript">
function popWindow(url,size){
		var path = cruConfig.currentPageUrl;
		if(path.indexOf("/epcomp") == 0){  
			path = path.substr("/epcomp".length);
		}	
		if(url.indexOf('/') == 0){
			if(url.indexOf(cruConfig.contextPath) != 0){
				url = cruConfig.contextPath + url; 
			}
		}
		else {
				path = path.substr(0,path.lastIndexOf("/")+1);
				if(path.lastIndexOf("/") == (path.length - 1)){
						url = cruConfig.contextPath + path + url;
				}
				else url = cruConfig.contextPath + path + '/' + url;
		}
		var height = 680;
		var width = 740;
		if(size != null){
			if(typeof size=='number'){
				height=size;
				}
			if(typeof size=='string'&&size.indexOf(':')>0){
				height = eval(size.split(':')[1]);
			  width = eval(size.split(':')[0]);
		  }
		}
		dialogOpen("",width,height,url);
	}

 </script>   
</body>
</html>
