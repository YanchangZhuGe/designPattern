<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	 String laborType ="";
	 if(request.getParameter("laborType")!=null && request.getParameter("laborType")!=""){
	  laborType=request.getParameter("laborType");
	 }
	  
	 String projectType=user.getProjectType();
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		} 
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
	 
	 String pFid= "";
		//查询是否 子项目
		String sqlButton = " select t.project_info_no,t.project_father_no ,t.project_name   from gp_task_project  t  where  t.project_info_no='"+projectInfoNo+"' and  t.bsflag='0' and t.project_father_no is not  null "; 
		List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlButton);
		//System.out.println("sql ="+list.size());	
		if(listF.size()>0){
		 	Map mapA = (Map)listF.get(0);
		 	  pFid= (String)mapA.get("projectFatherNo");
		 	
		}
		
		String orgS_id = (user==null)?"":user.getSubOrgIDofAffordOrg();
		
		  String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0'    start with t.org_sub_id = '"+orgS_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
			
			System.out.println("sql ="+sql);	
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			String orgSubIdA = "";
			String orgSubIdB = "";
			String orgSubIdC = "";
			String organ_flagA = "";
			String organ_flagB = "";
			String organ_flagC = "";
			
			if(list.size()>1){
			 	Map mapA = (Map)list.get(0);
			 	Map mapOrgB= (Map)list.get(1); 
				
//			 	if(mapOrgB == null){
//			 		mapOrgB= mapA;	 
//			 	} 
			 	
				orgSubIdA = (String)mapA.get("orgSubId");
				orgSubIdB = (String)mapOrgB.get("orgSubId"); 
				organ_flagA = (String)mapA.get("organFlag");
				organ_flagB = (String)mapOrgB.get("organFlag"); 
				
				if(organ_flagB.equals("")){
					if(organ_flagA.equals("1")){
						orgS_id = orgSubIdA;
					}
				}
				if(organ_flagB.equals("1")){
					orgS_id = orgSubIdB;
				}

				if(list.size()>2){ 
					Map mapOrgC = (Map)list.get(2);
					orgSubIdC = (String)mapOrgC.get("orgSubId");
					organ_flagC = (String)mapOrgC.get("organFlag");
					
					if(organ_flagC.equals("1")){
						orgS_id = orgSubIdC;
					}

					if(organ_flagC.equals("")){
						if(organ_flagB.equals("1")){
							orgS_id = orgSubIdB;
						}
					}
				}
			 
				
			 	if(organ_flagA.equals("0")||user.getOrgSubjectionId().equals("C105")){
			 		orgS_id = "C105";
			 	}
			}
			
			
			
			
			
			
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="<%=contextPath%>/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
<%@ include file="/common/pmd_list.jsp"%>
<title>列表页面</title>
</head>
<script language="javaScript">
<!--Remark JavaScript定义-->
var pageTitle = "正式工页面";
cruConfig.contextPath =  "<%=contextPath%>";
var genderOps = new Array(
['1','男'],['0','女'] 
);

var projectInfoNos = '<%=projectInfoNo%>';	 
var projectInfoId = '<%=projectInfoNo%>'; 
var orgS_id ='<%=orgS_id%>';
var pFid="<%=pFid%>";

var jcdp_codes_items = null;
var jcdp_codes = new Array(
);


function page_init(){
	var titleObj = getObj("cruTitle");
	if(titleObj!=undefined) titleObj.innerHTML = pageTitle;
	cruConfig.cdtType = 'form';
	cdt_init();
	<%-- cruConfig.queryStr = "select distinct e.employee_id,e.employee_name, e.employee_gender,decode(e.employee_gender, '1', '男', '0', '女')employee_gender_name,e.employee_id_code_no, hr.post, hr.post_level, d1.coding_name post_level_name   from comm_human_employee e  inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id   and hr.bsflag='0'  left join comm_coding_sort_detail d1 on hr.post_level = d1.coding_code_id and d1.bsflag = '0' left join view_human_project_relation r on e.employee_id=r.EMPLOYEE_ID where e.bsflag='0'    and r.actual_start_date is not null      and r.PROJECT_INFO_NO='<%=projectInfoNo%>' and hr.employee_gz='<%=laborType%>'";
	cruConfig.currentPageUrl = "/rm/em/humanLabor/humanTrainManage/humanListLink.jsp";
	queryData(1);--%>

	
	
	var projectInfoNo="";
	var zi_pid="";
	var pXFids="";
	var pSql="";
	//查询是否 子项目
    var sqlButton = " select t.project_info_no,t.project_father_no ,t.project_name   from gp_task_project  t  where  t.project_info_no='<%=projectInfoNo%>' and  t.bsflag='0' and t.project_father_no is not  null "; 
	var queryRetNum = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+sqlButton);		
	var datas = queryRetNum.datas; 
	if(datas != null && datas != ''){
		for (var i = 0; i< datas.length; i++) {
			projectInfoNo=datas[i].project_father_no; 	 
			zi_pid=datas[i].project_father_no; 
		}
		pSql=" where p.project_info_no='"+projectInfoId+"' ";
	}   
 
		// 处理井中业务 根据父项目查出所有主施工队伍 		 
		 var sqlZdui = " SELECT  p.project_info_no    AS project_info_no, p.project_type,  p.project_name      AS project_name,  p.project_common    AS project_common,  p.project_status     AS project_status,  ccsd.coding_name     AS manage_org_name,  NVL(p.project_start_time,p.acquire_start_time) AS start_date,  NVL(p.project_end_time,p.acquire_end_time)     AS end_date,  oi.org_abbreviation    AS team_name,  dy.is_main_team   AS is_main_team,dy.org_id,dy.org_subjection_id  , p.project_year,  p.project_father_no     FROM  gp_task_project p  JOIN  gp_task_project_dynamic dy  ON  dy.project_info_no = p.project_info_no  AND dy.bsflag = '0'  AND p.bsflag='0'  AND p.project_father_no ='"+projectInfoNo+"'   AND p.project_type='5000100004000000008'  AND dy.is_main_team ='1'  LEFT JOIN  comm_org_information oi  ON  dy.org_id = oi.org_id  LEFT JOIN  comm_coding_sort_detail ccsd  ON  p.manage_org = ccsd.coding_code_id  AND ccsd.bsflag = '0'  "; 
			var queryZdui = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10&querySql='+sqlZdui);		
			var datasZdui = queryZdui.datas; 
			if(datasZdui != null && datasZdui != ''){
				for (var i = 0; i< datasZdui.length; i++) {	 
	 
					//根据主施工队伍子项目 查询 ，所有相关协作 队伍 的  父id
				  // var sqlX = "  SELECT  p.project_info_no    AS project_info_no,    p.project_name      AS project_name,  p.project_common    AS project_common,  p.project_status     AS project_status,  ccsd.coding_name     AS manage_org_name,  NVL(p.project_start_time,p.acquire_start_time) AS start_date,  NVL(p.project_end_time,p.acquire_end_time)     AS end_date,  oi.org_abbreviation    AS team_name,  dy.is_main_team   AS is_main_team  , p.project_year,  p.project_father_no     FROM  gp_task_project p  JOIN  gp_task_project_dynamic dy  ON  dy.project_info_no = p.project_info_no  AND dy.bsflag = '0'  AND p.bsflag='0'  AND p.project_father_no ='"+projectInfoNo+"'   AND p.project_type='5000100004000000008'  AND dy.is_main_team ='1'  LEFT JOIN  comm_org_information oi  ON  dy.org_id = oi.org_id  LEFT JOIN  comm_coding_sort_detail ccsd  ON  p.manage_org = ccsd.coding_code_id  AND ccsd.bsflag = '0'  union all  SELECT  p.project_info_no    AS project_info_no,  p.project_name||'(协作)'    AS project_name,  p.project_common     AS project_common,  p.project_status      AS project_status,  ccsd.coding_name      AS manage_org_name,  NVL(p.project_start_time,p.acquire_start_time) AS start_date,  NVL(p.project_end_time,p.acquire_end_time)     AS end_date,  oi.org_abbreviation     AS team_name,  dy.is_main_team      AS is_main_team,  p.project_year ,  p.project_father_no   FROM  gp_task_project p   JOIN  gp_task_project_dynamic dy  ON  dy.project_info_no = p.project_info_no  AND p.project_year='"+datasZdui[i].project_year+"'  AND dy.bsflag = '0'  AND p.bsflag='0'  AND dy.org_id = '"+datasZdui[i].org_id+"'  AND p.project_type='5000100004000000008'  AND dy.is_main_team ='0'  LEFT JOIN  comm_org_information oi  ON  dy.org_id = oi.org_id  LEFT JOIN  comm_coding_sort_detail ccsd  ON  p.manage_org = ccsd.coding_code_id  AND ccsd.bsflag = '0'   " + pSql ; 
					var sqlX = "    SELECT  p.project_info_no    AS project_info_no,  p.project_name||'(协作)'    AS project_name,  p.project_common     AS project_common,  p.project_status      AS project_status,  ccsd.coding_name      AS manage_org_name,  NVL(p.project_start_time,p.acquire_start_time) AS start_date,  NVL(p.project_end_time,p.acquire_end_time)     AS end_date,  oi.org_abbreviation     AS team_name,  dy.is_main_team      AS is_main_team,  p.project_year ,  p.project_father_no   FROM  gp_task_project p   JOIN  gp_task_project_dynamic dy  ON  dy.project_info_no = p.project_info_no  AND p.project_year='"+datasZdui[i].project_year+"'  AND dy.bsflag = '0'  AND p.bsflag='0'  AND dy.org_id = '"+datasZdui[i].org_id+"'  AND p.project_type='5000100004000000008'  AND dy.is_main_team ='0'  LEFT JOIN  comm_org_information oi  ON  dy.org_id = oi.org_id  LEFT JOIN  comm_coding_sort_detail ccsd  ON  p.manage_org = ccsd.coding_code_id  AND ccsd.bsflag = '0'   " + pSql ;
						var queryX = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+sqlX);		
						var datasX = queryX.datas;  
						if(datasX != null && datasX != ''){
							for (var j = 0; j< datasX.length; j++) {  
								// 协作队伍的父项目id
								pXFids = pXFids + "," + "'" + datasX[j].project_father_no+ "'";
								
							}
						
						}  
						
						 
				}
			
			}  
			
 			//从其他项目转入的人员地震队项目互相转
			var  str  ="  select t.pk_ids,t.ptdetail_id,  t.xz_type zy_type, '' disasss, '是'   zy_sf,'1'employee_gender,'男' employee_gender_name,t.employee_id,t.employee_name, gp.project_name org_name,t.aproject_info_no org_subjection_id ,t.start_date actual_start_date,t.end_date actual_end_date , t.team_s team ,t.post_s work_post,t.team_name ,t.work_post_name , t.employee_gz ,t.employee_gz_name,'' dalei,   '' xiaolei,  case   when length(t.employee_cd)>10  then   ''     else  t.employee_cd     end employee_cd,   case   when length(t.employee_cd)>10  then   t.employee_cd   else   ''   end id_code,t.end_date employee_birth_date  from BGP_COMM_HUMAN_PT_DETAIL t  left join  gp_task_project gp on  t.aproject_info_no=gp.project_info_no and gp.bsflag='0'  where t.bsflag='0' and  t.bproject_info_no='<%=projectInfoNo%>' and t.end_date is null and t.pk_ids !='add' and t.employee_gz='<%=laborType%>' ";   // and t.pk_ids is null   当时怎么加 这个条件了
			//年度自己项目转移,不加项目转移‘是’列
			str += " union all  select t.pk_ids,t.ptdetail_id,  t.xz_type zy_type, 'disabled' disasss, ''   zy_sf,'1'employee_gender,'男' employee_gender_name,t.employee_id,t.employee_name, gp.project_name org_name,t.aproject_info_no org_subjection_id ,t.start_date actual_start_date,t.end_date actual_end_date , t.team_s team ,t.post_s work_post,t.team_name ,t.work_post_name , t.employee_gz ,t.employee_gz_name,'' dalei,   '' xiaolei, case   when length(t.employee_cd)>10  then   ''     else  t.employee_cd     end employee_cd,   case   when length(t.employee_cd)>10  then   t.employee_cd   else   ''   end id_code,t.end_date employee_birth_date  from BGP_COMM_HUMAN_PT_DETAIL t  left join  gp_task_project gp on  t.aproject_info_no=gp.project_info_no and gp.bsflag='0'  where t.bsflag='0' and t.end_date is null  and t.pk_ids='add'  and t.employee_gz='<%=laborType%>' ";  // and t.pk_ids='add'  当时怎么加 这个条件了
			//父项目转移的人员，在子项目看到
			if(zi_pid !=""){
				str += "  and  t.bproject_info_no='"+zi_pid+"' ";
			}else{
				str += "  and  t.bproject_info_no='<%=projectInfoNo%>' ";
			}
			//自己项目接收人员
			str += " union all   select '' pk_ids,'' ptdetail_id  , t.zy_type, 'disabled'  disasss,case  when t.zy_type is null  then '' else '是' end zy_sf,t.employee_gender,decode(t.employee_gender,'0','女','1','男') employee_gender_name ,t.EMPLOYEE_ID,t.EMPLOYEE_NAME,  t.ORG_NAME,      t.ORG_SUBJECTION_ID,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name,       t.dalei,    t.xiaolei ,T.EMPLOYEE_CD,T.ID_CODE, T.EMPLOYEE_BIRTH_DATE   from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where  t.actual_start_date is not null and  t.actual_end_date is null and t.employee_gz='<%=laborType%>'   ";
	 
      //父项目 id 不为空 ,那么就是子项目
     if(pFid !=null && pFid !="null"){   //选择项目为 子项目
    	 
    	// str +="  and t.PROJECT_FATHER_NO = '"+projectInfoNo+"' and  t.project_info_no =  '"+pFid+"' " ; // 自己项目人员
    	 str +="   and  t.project_info_no =  '<%=projectInfoNo%>' " ; // 自己项目人员
    	   if(orgS_id!=null && orgS_id!=""){
          	 if(orgS_id=="C105006"){
          		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
          	 }
          	 
           }  
    	  
    	 	 //查询父项目人员
    	 str +=" union all select '' pk_ids,'' ptdetail_id  ,  t.zy_type,'disabled'   disasss,case  when t.zy_type is null  then '' else '是' end zy_sf,t.employee_gender,decode(t.employee_gender,'0','女','1','男') employee_gender ,t.EMPLOYEE_ID,t.EMPLOYEE_NAME,  t.ORG_NAME,      t.ORG_SUBJECTION_ID,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name,       t.dalei,    t.xiaolei ,T.EMPLOYEE_CD,T.ID_CODE, T.EMPLOYEE_BIRTH_DATE   from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where  t.actual_start_date is not null and  t.actual_end_date is null  and t.employee_gz='<%=laborType%>'  and  t.project_info_no    in( '"+projectInfoNo+"'"+pXFids+" ) "; 
    	
    	   if(orgS_id!=null && orgS_id!=""){
          	 if(orgS_id=="C105006"){
          		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
          	 }
          	 
           }  
 	 	 

 	 	
     }else {  //选择项目为 父项目
    	   if(orgS_id!=null && orgS_id!=""){
          	 if(orgS_id=="C105006"){
          		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
          	 }
          	 
           }  
    	 str +="   and  t.project_info_no  in( '"+projectInfoNo+"'"+pXFids+" ) ";  //查询自己项目人员
    	 
      	 
         //var str1="  order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME  ";
	      str=str;
     }
     

	cruConfig.queryStr=str;
 	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanAttendance/humanAttendanceList.jsp";
	queryData(1); 
	
	cruConfig.editedColumnNames = "employee_gender"; 
	
	
}

var fields = new Array();
fields[0] = ['employee_name','姓名','TEXT'];
fields[1] = ['employee_gender','性别','TEXT',,,'SEL_OPs',genderOps];
	
function basicQuery(){
	var qStr = generateBasicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}


function cmpQuery(){
	var qStr = generateCmpQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function classicQuery(){
	var qStr = generateClassicQueryStr();
	cruConfig.cdtStr = qStr;
	queryData(1);
}

function onlineEdit(rowParams){
	var path = cruConfig.contextPath+cruConfig.editAction;
	var params = cruConfig.editTableParams+"&rowParams="+rowParams.toJSONString();
	var retObject = syncRequest('Post',path,params);
	if(retObject.returnCode!=0){
		alert(retObject.returnMsg);
		return false;
	}else return true;
}
//保存的checkbox拼接的值
var checked="";

function doCheck(id){

	//序号
	var num = -1;
	//新的check值
	var newcheck = "";
	//拼接的值不为空

	if(checked != ""){
		var checkStr = checked.split(",");
		for(var i=0;i<checkStr.length-1; i++){
			//如果check中存在  选择的id值
			if(checkStr[i] == id.value){
				//记录位置

				num = i;		
				break;	
			}
		}
        //判断num是否有值
		if(num != -1 ){
			if(id.checked==false){
				
				for(var j=0;j<checkStr.length-1; j++){
					if( j != num ){
						newcheck += checkStr[j] + ',';
					}
				}
				checked = newcheck;
			}
		}else{
			//直接拼
			if(id.checked==true){
				checked= checked + id.value + ',';	
			}		
		}
	}else{
		checked = id.value + ',';
		
	}
	

}
function JcdpButton0OnClick(){
	if(checked == ""){
		alert("请选择一条记录!");
		return;
	}
	window.returnValue = checked;
	window.close();  
}

function JcdpButton1OnClick(){
	window.returnValue = "";
	window.close(); 
}
</script>

<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
</head>
<body onload="page_init()">
<div id="queryDiv" style="display:">
<table  border="0" cellpadding="0" cellspacing="0" class="form_info" id="queryCdtTable" enctype="multipart/form-data">
  <tr class="ali4">
    <td colspan="4"><input type="submit" onclick="classicQuery()" name="search" value="查询"  class="iButton2"/>  <input type="reset" name="reset" value="清除" onclick="clearQueryCdt()" class="iButton2"/></td>
  </tr>  
</table>
</div>
</div>
<div id="lidiv" >
<table  border="0" cellpadding="0" cellspacing="0" class="Tab_new_mod_del">
  <tr class="ali7">
    <td>
		<input class="iButton2" type="button" value="保存" onClick="JcdpButton0OnClick()">
		<input class="iButton2" type="button" value="返回" onClick="JcdpButton1OnClick()">
    </td>
  </tr>
</table>
</div>
<!--Remark 查询指示区域-->
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td align="right" >
			<span id="dataRowHint">第0/0页,共0条记录 </span>
			<table id="navTableId" border="0"  cellpadding="0"  cellspacing="0" style="display:inline">
				<tr>
					<td><img src="<%=contextPath%>/images/table/firstPageDisabled.gif"  style="border:0"  alt="First" /></td>
					<td><img src="<%=contextPath%>/images/table/prevPageDisabled.gif"  style="border:0"  alt="Prev" /></td>
					<td><img src="<%=contextPath%>/images/table/nextPageDisabled.gif"  style="border:0"  alt="Next" /></td>
					<td><img src="<%=contextPath%>/images/table/lastPageDisabled.gif"  style="border:0"  alt="Last" /></td>				
				</tr>
			</table>
			<span>到&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;页<a href='javascript:changePage()'><img src='<%=contextPath%>/images/table/bullet_go.gif' alt='Go' align="absmiddle" /></a></span>		
		</td>
	</tr>
</table>
</div>

<div id="resultable"  style="width:100%; overflow-x:scroll ;" >
<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>

	<tr class="bt_info">
   	    <td class="tableHeader" 	 exp="<input type='radio' name='chx_entity_id'  value='{employee_id}-{employee_name}-{employee_gender}-{employee_cd}-{work_post_name}' onclick=doCheck(this) />"></td>
		<td class="tableHeader" 	 exp="{employee_id}" isShow="TextHide" style="display:none">employee_id</td>
		<td class="tableHeader" 	 exp="{employee_name}">姓名</td>
		<td class="tableHeader" 	 exp="{employee_gender}" isShow="Hide" style="display:none">性别</td>
		<td class="tableHeader" 	 exp="{employee_gender_name}">性别</td>
		<td class="tableHeader" 	 exp="{employee_cd}">人员编号</td>
		<td class="tableHeader" 	 exp="{work_post_name}">岗位</td>
 
		
	</tr>
	</thead>
	<tbody>
	
	</tbody>
</table>
</div>
</body>
</html>
