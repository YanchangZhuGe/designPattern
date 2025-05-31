<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %> 
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%> 
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
 


<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
	String zPview = request.getParameter("zPview");
	String projectType = user.getProjectType();	
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
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
			
//		 	if(mapOrgB == null){
//		 		mapOrgB= mapA;	 
//		 	} 
		 	
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

 <title>项目页面</title> 
 </head> 
 <body style="background:#fff" onload="refreshData();getApplyTeam();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>		
			  	<td  width="4%">姓名</td>
			    <td width="5%"  ><input style="width:100px;" id="s_employee_name" name="s_employee_name" value=""/>	    <input type='hidden' id="checkall" name="checkall" value="0"/></td>	
			  	<td width="5%" >&nbsp;班组</td>
			    <td width="5%" ><select style="width:100px;" id="s_apply_team" name="s_apply_team"></select></td>	
			    <td width="8%" >&nbsp;用工性质</td>
			    <td width="5%" >
			    <select style="width:100px;" id="s_employee_gz" name="s_employee_gz">
			    <option value="">请选择</option><option value="0110000019000000001">合同化员工</option><option value="0110000019000000002">市场化用工</option>
			    <option value="0110000059000000005">临时季节性用工</option><option value="0110000059000000001">再就业</option><option value="0110000059000000003">劳务用工</option>
			    </select>
			    </td>	
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		        </td>
		        <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>        
			    <td>&nbsp;</td>
			   	<auth:ListButton functionId="" css="rlfprw" event="onclick='toAdd()'" title="项目转移(返还)"></auth:ListButton>	
			    <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>  	 
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
			     <td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id'  {disasss}  value='{employee_id}-{employee_gz}-{zy_type}-{pk_ids}-{ptdetail_id}' id='rdo_entity_id'/>" >
 				<input type='checkbox' id='headChxBox'  onclick="head_chx_box_changed(this)"/></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{employee_name}">员工姓名</td>
			  	    <td class="bt_info_odd" 	 exp="{employee_gender}" isShow="Hide" style="display:none">性别</td>
					<td class="bt_info_odd" 	 exp="{employee_cd}" isShow="Hide" style="display:none">人员编号</td>
					<td class="bt_info_odd" 	 exp="{id_code}" isShow="Hide" style="display:none">身份证号</td>
					<td class="bt_info_odd" 	 exp="{employee_birth_date}" isShow="Hide" style="display:none">出生年月</td> 
					
			      <td class="bt_info_odd" exp="{org_name}">组织机构/转出项目</td>
			      <td class="bt_info_even" exp="{team_name}">班组</td>
			      <td class="bt_info_odd" exp="{work_post_name}">岗位</td>
			      <td class="bt_info_even" exp="{actual_start_date}">实际进入项目实际</td>
			      <td class="bt_info_odd" exp="{employee_gz_name}">用工性质</td>
			      <td class="bt_info_even" exp="{zy_sf}">项目转移</td>
			      
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
			<div style="width:100%;height:250px">
			<iframe width="100%" height="100%" name="mes" id="mes" frameborder="0" src="" marginheight="0" marginwidth="0" >
			</iframe>
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
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';
 
	var projectInfoId = '<%=projectInfoNo%>'; 
	var orgS_id ='<%=orgS_id%>';
	
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			var q_file_name = document.getElementById("s_employee_name").value;
			refreshData(undefined, q_file_name);
		}
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
		
		var s_employee_name = document.getElementById("s_employee_name").value; 
		var s_employee_gz = document.getElementById("s_employee_gz").value; 
		var s_apply_team = document.getElementById("s_apply_team").value;
		
		var str = " 1=1 ";
		if(s_employee_name!=''){
			str += " and employee_name like '%"+s_employee_name+"%' ";
		}
		if(s_employee_gz!=''){
			str += " and employee_gz like '%"+s_employee_gz+"%' ";
		}
		if(s_apply_team != ''){
			str+=" and team='"+s_apply_team+"'";
		}

		cruConfig.cdtStr = str;
		refreshData();

	}
 
	function toAdd() {	
	 
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
	  
		var tempIds = ids.split(",");		
		var zy_type="";
		var pk_id_zs="";
		var pk_id_ls="";
		var ptdetail_id="";
	 
		
		for(var i=0;i<tempIds.length;i++){		
			zy_type=tempIds[i].split("-")[2];
			
			if(zy_type == "1"){ //zs
				
				pk_id_zs= pk_id_zs + "," + "'" + tempIds[i].split("-")[3] + "'";	
				
			}else if  (zy_type == "0") {//ls
				pk_id_ls=pk_id_ls + "," + "'" + tempIds[i].split("-")[3] + "'";	
				
			}
			ptdetail_id = ptdetail_id + "," + "'" + tempIds[i].split("-")[4] + "'";	 
		}
 
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanLedger/add_returnModify.jsp?taskIds='+taskIds+'&pk_id_zs='+pk_id_zs.substr(1)+'&pk_id_ls='+pk_id_ls.substr(1)+'&ptdetail_id='+ptdetail_id.substr(1),'1000:800');

	}
	
	
	function clearQueryText(){ 
		 document.getElementById("s_employee_name").value=""; 
		 document.getElementById("s_employee_gz").value=""; 
		 document.getElementById("s_apply_team").value="";
	     cruConfig.cdtStr = "";
	}
	var pFid="<%=zPview%>";
	function refreshData(taskId,projectInfoNo,arrObj){
		if(taskId==undefined){
			taskId = taskIds;
		}
		if(projectInfoNo==undefined){
			projectInfoNo = projectInfoNos;
		}
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
				var  str  ="  select t.pk_ids,t.ptdetail_id,  t.xz_type zy_type, '' disasss, '是'   zy_sf,''employee_gender,t.employee_id,t.employee_name, gp.project_name org_name,t.aproject_info_no org_subjection_id ,t.start_date actual_start_date,t.end_date actual_end_date , t.team_s team ,t.post_s work_post,t.team_name ,t.work_post_name , t.employee_gz ,t.employee_gz_name,'' dalei,   '' xiaolei,  case   when length(t.employee_cd)>10  then   ''     else  t.employee_cd     end employee_cd,   case   when length(t.employee_cd)>10  then   t.employee_cd   else   ''   end id_code,t.end_date employee_birth_date  from BGP_COMM_HUMAN_PT_DETAIL t  left join  gp_task_project gp on  t.aproject_info_no=gp.project_info_no and gp.bsflag='0'  where t.bsflag='0' and  t.bproject_info_no='<%=projectInfoNo%>' and t.end_date is null and t.pk_ids !='add' ";   // and t.pk_ids is null   当时怎么加 这个条件了
				//年度自己项目转移,不加项目转移‘是’列
				str += " union all  select t.pk_ids,t.ptdetail_id,  t.xz_type zy_type, 'disabled' disasss, ''   zy_sf,''employee_gender,t.employee_id,t.employee_name, gp.project_name org_name,t.aproject_info_no org_subjection_id ,t.start_date actual_start_date,t.end_date actual_end_date , t.team_s team ,t.post_s work_post,t.team_name ,t.work_post_name , t.employee_gz ,t.employee_gz_name,'' dalei,   '' xiaolei,  case   when length(t.employee_cd)>10  then   ''     else  t.employee_cd     end employee_cd,   case   when length(t.employee_cd)>10  then   t.employee_cd   else   ''   end id_code,t.end_date employee_birth_date  from BGP_COMM_HUMAN_PT_DETAIL t  left join  gp_task_project gp on  t.aproject_info_no=gp.project_info_no and gp.bsflag='0'  where t.bsflag='0' and t.end_date is null  and t.pk_ids='add'  ";  // and t.pk_ids='add'  当时怎么加 这个条件了
				//父项目转移的人员，在子项目看到
				if(zi_pid !=""){
					str += "  and  t.bproject_info_no='"+zi_pid+"' ";
				}else{
					str += "  and  t.bproject_info_no='<%=projectInfoNo%>' ";
				}
				//自己项目接收人员
				str += " union all   select '' pk_ids,'' ptdetail_id  , t.zy_type, 'disabled'  disasss,case  when t.zy_type is null  then '' else '是' end zy_sf,decode(t.employee_gender,'0','女','1','男') employee_gender ,t.EMPLOYEE_ID,t.EMPLOYEE_NAME,  t.ORG_NAME,      t.ORG_SUBJECTION_ID,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name,       t.dalei,    t.xiaolei ,T.EMPLOYEE_CD,T.ID_CODE, T.EMPLOYEE_BIRTH_DATE   from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where  t.actual_start_date is not null and  t.actual_end_date is null   ";
		 
          //父项目 id 不为空 ,那么就是子项目
         if(pFid !=null && pFid !="null"){   //选择项目为 子项目
        	 
        	// str +="  and t.PROJECT_FATHER_NO = '"+projectInfoNo+"' and  t.project_info_no =  '"+pFid+"' " ; // 自己项目人员
        	 str +="   and  t.project_info_no =  '<%=projectInfoNo%>' " ; // 自己项目人员
        	   if(orgS_id!=null && orgS_id!=""){
              	 if(orgS_id=="C105006"){
              		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
              	 }
              	 
               }  
        	 	for(var key in arrObj) { 
         			//alert(arrObj[key].label+arrObj[key].value);
         			if(arrObj[key].value!=undefined && arrObj[key].value!='')
         			str += "and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
         		}
        	 	 //查询父项目人员
        	 str +=" union all select '' pk_ids,'' ptdetail_id  ,  t.zy_type,'disabled'   disasss,case  when t.zy_type is null  then '' else '是' end zy_sf,decode(t.employee_gender,'0','女','1','男') employee_gender ,t.EMPLOYEE_ID,t.EMPLOYEE_NAME,  t.ORG_NAME,      t.ORG_SUBJECTION_ID,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name,       t.dalei,    t.xiaolei ,T.EMPLOYEE_CD,T.ID_CODE, T.EMPLOYEE_BIRTH_DATE   from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where  t.actual_start_date is not null and  t.actual_end_date is null    and  t.project_info_no    in( '"+projectInfoNo+"'"+pXFids+" ) "; 
        	
        	   if(orgS_id!=null && orgS_id!=""){
              	 if(orgS_id=="C105006"){
              		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
              	 }
              	 
               }  
     	 	for(var key in arrObj) { 
     			//alert(arrObj[key].label+arrObj[key].value);
     			if(arrObj[key].value!=undefined && arrObj[key].value!='')
     			str += "and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
     		}

     	 	
         }else {  //选择项目为 父项目
        	   if(orgS_id!=null && orgS_id!=""){
              	 if(orgS_id=="C105006"){
              		 str +="  and t.ORG_SUBJECTION_ID like '"+orgS_id+"%' ";
              	 }
              	 
               }  
        	 str +="   and  t.project_info_no  in( '"+projectInfoNo+"'"+pXFids+" ) ";  //查询自己项目人员
        	 
          	for(var key in arrObj) { 
     			//alert(arrObj[key].label+arrObj[key].value);
     			if(arrObj[key].value!=undefined && arrObj[key].value!='')
     			str += "and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
     		}
             //var str1="  order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME  ";
		      str=str;
         }
         

		cruConfig.queryStr=str;
     	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanLedger/rootPlanList.jsp";
		queryData(1); 
	 
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanLedger/doc_search.jsp');
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

    function loadDataDetail(ids){
    	var id = ids.split("-")[0];
    	if("0110000019000000001,0110000019000000002".indexOf(ids.split("-")[1]) != -1){
    		document.getElementById("mes").src ="<%=contextPath%>/rm/em/commHumanInfo/commHumanList1.jsp?employeeId="+id+"&projectInfoNo="+projectInfoNos;		
    	}else{
    		document.getElementById("mes").src ="<%=contextPath%>/rm/em/commHumanInfo/commHumanList2.jsp?employeeId="+id+"&projectInfoNo="+projectInfoNos;		
    	}
			
	 }
	
    function getApplyTeam(){
    	var selectObj = document.getElementById("s_apply_team"); 
    	document.getElementById("s_apply_team").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);

    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","");	
    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
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
</script>
</html>