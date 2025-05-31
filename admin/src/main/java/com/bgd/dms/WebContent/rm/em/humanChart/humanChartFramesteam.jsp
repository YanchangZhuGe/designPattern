<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath=request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String projectInfoNo = user.getProjectInfoNo();
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
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>
<title>无标题文档</title>
<style type="text/css">
.select_height{height:20px;margin:0,0,0,0;}
SELECT {
	margin-bottom:0;
    margin-top:0;
	border:1px #52a5c4 solid;
	color: #333333;
	FONT-FAMILY: "微软雅黑";font-size:9pt;
}
.tongyong_box_title {
	width:100%;
	height:auto;
	background:url(<%=contextPath%>/dashboard/images/titlebg.jpg);
	text-align:left;
	text-indent:12px;
	font-weight:bold;
	font-size:14px;
	color:#0f6ab2;
	line-height:22px;
}
</style>
</head>
<body style="background: #fff; overflow-y: auto"  onload="getFusionChart();getTableListData();">
<div id="list_content">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" id="td0">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">一线员工用工性质分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left"  id="chartContainer1" style="height: 250px;">
			 
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">项目岗位人员统计</a>
							<span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer2" style="height: 250px;">
							<table id="teamMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						    	<tr class="bt_info">
						    	    <td width="20%">&nbsp;</td>
						            <td width="20%">合计</td>
						            <td width="20%">管理类</td>
						            <td width="20%">专业技术类</td>
						            <td width="20%">技能操作类</td>
						        </tr>            
					        </table>
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="49%">
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">项目人员年龄结构分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer3" style="height: 250px;">
							<table id="ageMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						    	<tr class="bt_info">
						    	    <td>年龄</td>
						            <td>人数</td>
						        </tr>            
					        </table>
						</div>
						</div>
						</td>
						<td width="1%"></td>
						<td>
						<div class="tongyong_box">
						<div class="tongyong_box_title"><span class="kb"><a
							href="#"></a></span><a href="#">项目人员学历结构分析</a><span class="gd"><a
							href="#"></a></span></div>
						<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;">
							<table id="educationMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
						    	<tr class="bt_info">
						    	    <td>学历</td>
						            <td>人数</td>
						        </tr>            
					        </table>
						</div>
						</div>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
			<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="49%">
					<div class="tongyong_box">
					<div class="tongyong_box_title"><span class="kb"><a
						href="#"></a></span><a href="#">计划与接收人数对比</a><span class="gd"><a
						href="#"></a></span></div>
					<div class="tongyong_box_content_left" id="chartContainer4" style="height: 250px;">
						<table id="projectMan" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					    	<tr class="bt_info">
					    	    <td width="20%">&nbsp;</td>
					            <td width="10%">计划人数</td>
					            <td width="10%">调配人数</td>
					            <td width="20%">接收人数(正式工)</td> 
					            <td width="10%">返还人数</td>
					            <td width="20%">接收人数(临时工)</td>
					            <td width="10%">返还人数</td>
					        </tr>            
				        </table>
					</div>
					</div>
					</td>
					<td width="49%"></td>
					 
				</tr>
			</table>
			</td>
		</tr>
		
		</table>
		</td>
	<td width="1%"></td>
	</tr>
</table>
</div>
</body>
<script type="text/javascript">

var projectInfoNo = '<%=projectInfoNo%>';
var projectType = '<%=projectType%>';

 function getFusionChart(){
    
	var myChart1 = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Pie3D.swf", "myChartId1", "100%", "250", "0", "0" );    
	myChart1.setXMLUrl("<%=contextPath%>/cache/rm/em/getChart17.srq?projectInfoNo=<%=projectInfoNo%>");      
	myChart1.render("chartContainer1");  
	getChart2();
	getTeamNum();
}
  
 function getFusionChart2(team){
	 popWindow('<%=contextPath%>/rm/em/humanChart/humanChart18-2.jsp?projectInfoNo='+projectInfoNo+'&team='+team,'800:700');
 }
 function getChart2(){
	 
		var querySql = "select tm.team,nvl(tm.team_name,'合计') team_name,count(1) nn,sum(case when tm.post_sort='0110000021000000001' then 1 else 0 end ) n1,sum(case when tm.post_sort='0110000021000000002' then 1 else 0 end ) n2,sum(case when tm.post_sort='0110000021000000003' then 1 else 0 end ) n3 from (select distinct d.employee_id,d1.coding_name team_name,d.team,h.post_sort  from bgp_human_prepare_human_detail d  left join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.bsflag = '0' and p.prepare_status='2'  left join comm_human_employee e on e.employee_id = d.employee_id  left join comm_human_employee_hr h on e.employee_id = h.employee_id left join comm_coding_sort_detail d1 on d.team=d1.coding_code_id  where d.bsflag = '0'  and d.actual_start_date is not null    and p.project_info_no='"+projectInfoNo+"'  and h.post_sort is not null  ) tm group by rollup(tm.team,tm.team_name) having (tm.team_name is not null or (tm.team_name is null  and tm.team is null)) order by tm.team desc ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length ; i++) {
				
				
				var tr = document.getElementById("teamMap").insertRow();		
				
           		if(i % 2 == 1){  
           			tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				
           		var team = datas[i].team;
           		
           		if(i==0){
           			
    				var td = tr.insertCell(0);
    				td.innerHTML = datas[i].team_name;
    				
    				var td = tr.insertCell(1);
    				td.innerHTML = "<a href=javascript:getHumanList('','')>"+datas[i].nn+"</a>";	
    				
    				var td = tr.insertCell(2);
    				td.innerHTML = "<a href=javascript:getHumanList('','0110000021000000001')>"+datas[i].n1+"</a>";	
    				
    				var td = tr.insertCell(3);
    				td.innerHTML = "<a href=javascript:getHumanList('','0110000021000000002')>"+datas[i].n2+"</a>";	
    				
    				var td = tr.insertCell(4);
    				td.innerHTML = "<a href=javascript:getHumanList('','0110000021000000003')>"+datas[i].n3+"</a>";	
           			
           		}else{
           			
    				var td = tr.insertCell(0);
    				td.innerHTML = "<a href=javascript:getFusionChart2('"+team+"')>"+datas[i].team_name+"</a>";
    				
    				var td = tr.insertCell(1);
    				td.innerHTML = "<a href=javascript:getHumanList('"+team+"','')>"+datas[i].nn+"</a>";	
    				
    				var td = tr.insertCell(2);
    				td.innerHTML = "<a href=javascript:getHumanList('"+team+"','0110000021000000001')>"+datas[i].n1+"</a>";	
    				
    				var td = tr.insertCell(3);
    				td.innerHTML = "<a href=javascript:getHumanList('"+team+"','0110000021000000002')>"+datas[i].n2+"</a>";	
    				
    				var td = tr.insertCell(4);
    				td.innerHTML = "<a href=javascript:getHumanList('"+team+"','0110000021000000003')>"+datas[i].n3+"</a>";	
    				
           		}
           		
			}
		}	
		
 }
 
 function getTeamNum(){
	 //sum(C.C_N)C  
	     //旧sql业务
		//var querySql = " select decode(A.LABELS,'','合计:',LABELS) LABELS,sum(B.B_N)B, SUM(D.D_N)-  SUM(F.F_N) C,SUM(D.D_N)D,SUM(F.F_N)F from ( SELECT t.coding_code_id AS value,t.coding_name AS labels FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001'  and t.coding_mnemonic_id ='"+projectType+"' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) <= 2  order by t.coding_show_id   ) A full join   (select tm.apply_team,          sum(tm.people_number) B_N   from      (select distinct  d.people_number,      d1.coding_name team_name,      d.apply_team,      d.post as  post_sort    from bgp_comm_human_plan_detail d      left join comm_coding_sort_detail d1       on d.apply_team = d1.coding_code_id    where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'      and d.post  is not null) tm  group by rollup(tm.apply_team, tm.team_name) having(tm.team_name is not null or (tm.team_name is null and tm.apply_team is null)) order by tm.apply_team desc   ) B ON A.value=B.apply_team ";
		 //   querySql+="  full join  ( select tm.team,   count(1) C_N    from (   select   t.team,     d2.coding_name team_name    from bgp_human_prepare_human_detail t   inner join bgp_human_prepare r        on t.prepare_no = r.prepare_no    and r.bsflag = '0'         left join comm_coding_sort_detail d2     on t.team = d2.coding_code_id     left join comm_human_employee e   on t.employee_id = e.employee_id    and e.bsflag = '0'      where  r.project_info_no = '"+projectInfoNo+"'        union all   select   d2.apply_team as team,  d3.coding_name team_name   from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l    on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id   left join bgp_comm_human_receive_labor clr   on clr.deploy_detail_id = d2.deploy_detail_id and clr.bsflag='0' where t.bsflag = '0'   and t.project_info_no =  '"+projectInfoNo+"'    )tm     left join comm_coding_sort_detail d1    on tm.team = d1.coding_code_id     group by rollup(tm.team, tm.team_name)  having(tm.team_name is not null or (tm.team_name is null and tm.team is null) )  order by tm.team desc   ) C   ON A.value=C.team  ";
		 //   querySql +=" full join   (  select tm.team,   count(1) D_N    from (   select distinct d.team,d.spare1,d.actual_start_date,d.bsflag,d.prepare_no,d.employee_id, cd.coding_name team_name      from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p     on d.prepare_no = p.prepare_no    and p.prepare_status = '2'   left join bgp_project_human_relation r     on d.employee_id = r.employee_id    and p.project_info_no = r.project_info_no    and r.team = d.team    and r.work_post = d.work_post   left join common_busi_wf_middle te     on te.business_id = p.prepare_no    and te.bsflag = '0'   left join bgp_project_human_profess pr1     on pr1.profess_no = p.profess_no    and p.profess_no is not null    and pr1.bsflag = '0'   left join bgp_project_human_requirement pr     on pr.requirement_no = p.requirement_no    and p.requirement_no is not null    and pr.bsflag = '0'   left join comm_org_subjection su     on pr.apply_company = su.org_id   left join bgp_project_human_relief re     on re.human_relief_no = p.human_relief_no    and p.human_relief_no is not null    and re.bsflag = '0'   left join comm_human_employee e    on d.employee_id = e.employee_id  left join comm_human_employee_hr h     on d.employee_id = h.employee_id   left join gp_task_project t     on p.project_info_no = t.project_info_no   left join comm_coding_sort_detail cd     on d.team = cd.coding_code_id  where p.bsflag = '0'    and d.bsflag = '0'    and p.project_info_no = '"+projectInfoNo+"'    and (te.business_id is null or te.proc_status = '3')    and d.actual_start_date is not null    and (d.spare1 is null or d.spare1 = '1')    union all   select   d2.apply_team as team,''as spare1, t.start_date as actual_start_date,t.bsflag,clr.receive_no as prepare_no,   t.labor_id as employee_id,   d3.coding_name team_name   from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l    on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id   left join bgp_comm_human_receive_labor clr   on clr.deploy_detail_id = d2.deploy_detail_id and clr.bsflag='0' where t.bsflag = '0'   and t.project_info_no =  '"+projectInfoNo+"'     ) tm       left join comm_coding_sort_detail d1     on tm.team = d1.coding_code_id           group by rollup(tm.team, tm.team_name)  having(tm.team_name is not null or (tm.team_name is null and tm.team is null)) order by tm.team desc     )D  ON A.VALUE=D.team ";
		 //   querySql +=" full join (  select tm.team,  count(1) F_N       from (   select distinct  d.team,d.spare1,d.actual_start_date,d.bsflag,d.prepare_no,d.employee_id, cd.coding_name team_name   from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.prepare_status='2'   left join bgp_project_human_relation r on d.employee_id = r.employee_id  and p.project_info_no = r.project_info_no and r.team=d.team and r.work_post=d.work_post  left join common_busi_wf_middle te on te.business_id=p.prepare_no and te.bsflag='0'  left join bgp_project_human_profess pr1 on pr1.profess_no=p.profess_no and p.profess_no is not null and pr1.bsflag='0'  left join comm_org_subjection su2 on pr1.apply_company=su2.org_id  left join bgp_project_human_requirement pr on pr.requirement_no=p.requirement_no and p.requirement_no is not null and pr.bsflag='0'   left join comm_org_subjection su on pr.apply_company=su.org_id  left join bgp_project_human_relief re on re.human_relief_no=p.human_relief_no and p.human_relief_no is not null and re.bsflag='0'    left join comm_human_employee e on d.employee_id = e.employee_id  left join comm_human_employee_hr h on d.employee_id = h.employee_id  left join gp_task_project t on p.project_info_no = t.project_info_no  left join comm_coding_sort_detail cd on d.team = cd.coding_code_id    where p.bsflag = '0' and d.bsflag='0'  and p.project_info_no = '"+projectInfoNo+"'  and ( te.business_id is null or te.proc_status='3' ) and d.actual_end_date is not null and d.spare2='1'  and (d.spare1 is null or d.spare1='1' )    union all   select   d2.apply_team as team,''as spare1, t.start_date as actual_start_date,t.bsflag,clr.receive_no as prepare_no,   t.labor_id as employee_id,   d3.coding_name team_name   from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l    on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id   left join bgp_comm_human_receive_labor clr   on clr.deploy_detail_id = d2.deploy_detail_id and clr.bsflag='0' where t.bsflag = '0'   and t.project_info_no =  '"+projectInfoNo+"'   and t.end_date is not null    ) tm   left join comm_coding_sort_detail d1      on tm.team = d1.coding_code_id      group by rollup(tm.team, tm.team_name)     having(tm.team_name is not null or (tm.team_name is null and tm.team is null)) order by tm.team desc     )F on A.value=f.team GROUP BY A.LABELS   ORDER BY A.LABELS DESC ";
	
		   var querySql ="select decode(A.LABELS, '', '合计:', LABELS) LABELS,  sum(B.B_N) B,   SUM(D.D_N) C,   SUM(F.F_N) ZJS,   SUM(H.H_N) ZFH,   SUM(G.G_N) LJS,   SUM(K.K_N) LFH    from (SELECT t.coding_code_id AS value,  t.coding_name    AS labels  FROM comm_coding_sort_detail t  where t.coding_sort_id = '0110000001'  and t.coding_mnemonic_id = '"+projectType+"'  and t.bsflag = '0'  and t.spare1 = '0'  and length(t.coding_code) <= 2  order by t.coding_show_id) A  full join (select tm.apply_team, sum(tm.people_number) B_N  from (select distinct d.people_number,  d1.coding_name  team_name,  d.apply_team,  d.post          as post_sort  from bgp_comm_human_plan_detail d  left join comm_coding_sort_detail d1  on d.apply_team = d1.coding_code_id  where d.bsflag = '0'  and d.project_info_no =  '"+projectInfoNo+"'  and d.post is not null) tm  group by rollup(tm.apply_team, tm.team_name)  having(tm.team_name is not null or (tm.team_name is null and tm.apply_team is null))  order by tm.apply_team desc) B  ON A.value = B.apply_team  ";
		  	   querySql+="  full join (select tm.team, count(1) D_N  from (select distinct d.team,  d.spare1,  d.actual_start_date,  d.bsflag,  d.prepare_no,  d.employee_id,  cd.coding_name team_name  from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p  on d.prepare_no = p.prepare_no  and p.prepare_status = '2'  left join bgp_project_human_relation r  on d.employee_id = r.employee_id  and p.project_info_no =  r.project_info_no  and r.team = d.team  and r.work_post = d.work_post  left join common_busi_wf_middle te  on te.business_id = p.prepare_no  and te.bsflag = '0'  left join bgp_project_human_profess pr1  on pr1.profess_no = p.profess_no  and p.profess_no is not null  and pr1.bsflag = '0'  left join bgp_project_human_requirement pr  on pr.requirement_no =  p.requirement_no  and p.requirement_no is not null  and pr.bsflag = '0'  left join comm_org_subjection su  on pr.apply_company = su.org_id  left join bgp_project_human_relief re  on re.human_relief_no =  p.human_relief_no  and p.human_relief_no is not null  and re.bsflag = '0'  left join comm_human_employee e  on d.employee_id = e.employee_id  left join comm_human_employee_hr h  on d.employee_id = h.employee_id  left join gp_task_project t  on p.project_info_no =  t.project_info_no  left join comm_coding_sort_detail cd  on d.team = cd.coding_code_id  where p.bsflag = '0'  and d.bsflag = '0'  and p.project_info_no =  '"+projectInfoNo+"'  and (te.business_id is null or  te.proc_status = '3')   and (d.spare1 is null or  d.spare1 = '1')  ) tm  left join comm_coding_sort_detail d1  on tm.team = d1.coding_code_id  group by rollup(tm.team, tm.team_name)  having(tm.team_name is not null or (tm.team_name is null and tm.team is null))  order by tm.team desc) D  ON A.VALUE = D.team  ";
			   querySql+="  full join (select tm.team, count(1) F_N  from (select distinct d.team,  d.spare1,  d.actual_start_date,  d.bsflag,  d.prepare_no,  d.employee_id,  cd.coding_name team_name  from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p  on d.prepare_no = p.prepare_no  and p.prepare_status = '2'  left join bgp_project_human_relation r  on d.employee_id = r.employee_id  and p.project_info_no =  r.project_info_no  and r.team = d.team  and r.work_post = d.work_post  left join common_busi_wf_middle te  on te.business_id = p.prepare_no  and te.bsflag = '0'  left join bgp_project_human_profess pr1  on pr1.profess_no = p.profess_no  and p.profess_no is not null  and pr1.bsflag = '0'  left join comm_org_subjection su2  on pr1.apply_company = su2.org_id  left join bgp_project_human_requirement pr  on pr.requirement_no =  p.requirement_no  and p.requirement_no is not null  and pr.bsflag = '0'  left join comm_org_subjection su  on pr.apply_company = su.org_id  left join bgp_project_human_relief re  on re.human_relief_no =  p.human_relief_no  and p.human_relief_no is not null  and re.bsflag = '0'  left join comm_human_employee e  on d.employee_id = e.employee_id  left join comm_human_employee_hr h  on d.employee_id = h.employee_id  left join gp_task_project t  on p.project_info_no =  t.project_info_no  left join comm_coding_sort_detail cd  on d.team = cd.coding_code_id  where p.bsflag = '0'  and d.bsflag = '0'  and p.project_info_no =  '"+projectInfoNo+"'  and (te.business_id is null or  te.proc_status = '3')  and d.actual_start_date is not  null     and (d.spare1 is null or  d.spare1 = '1')  ) tm  left join comm_coding_sort_detail d1  on tm.team = d1.coding_code_id  group by rollup(tm.team, tm.team_name)  having(tm.team_name is not null or (tm.team_name is null and tm.team is null))  order by tm.team desc) F  on A.value = F.team ";    
			   querySql+=" full join (select tm.team, count(1) H_N  from (select distinct d.team,  d.spare1,  d.actual_start_date,  d.bsflag,  d.prepare_no,  d.employee_id,  cd.coding_name team_name  from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p  on d.prepare_no = p.prepare_no  and p.prepare_status = '2'  left join bgp_project_human_relation r  on d.employee_id = r.employee_id  and p.project_info_no =  r.project_info_no  and r.team = d.team  and r.work_post = d.work_post  left join common_busi_wf_middle te  on te.business_id = p.prepare_no  and te.bsflag = '0'  left join bgp_project_human_profess pr1  on pr1.profess_no = p.profess_no  and p.profess_no is not null  and pr1.bsflag = '0'  left join comm_org_subjection su2  on pr1.apply_company = su2.org_id  left join bgp_project_human_requirement pr  on pr.requirement_no =  p.requirement_no  and p.requirement_no is not null  and pr.bsflag = '0'  left join comm_org_subjection su  on pr.apply_company = su.org_id  left join bgp_project_human_relief re  on re.human_relief_no =  p.human_relief_no  and p.human_relief_no is not null  and re.bsflag = '0'  left join comm_human_employee e  on d.employee_id = e.employee_id  left join comm_human_employee_hr h  on d.employee_id = h.employee_id  left join gp_task_project t  on p.project_info_no =  t.project_info_no  left join comm_coding_sort_detail cd  on d.team = cd.coding_code_id  where p.bsflag = '0'  and d.bsflag = '0'  and p.project_info_no =  '"+projectInfoNo+"'  and (te.business_id is null or  te.proc_status = '3')  and d.actual_end_date is not null  and d.spare2 = '1'  and (d.spare1 is null or  d.spare1 = '1')  ) tm  left join comm_coding_sort_detail d1  on tm.team = d1.coding_code_id  group by rollup(tm.team, tm.team_name)  having(tm.team_name is not null or (tm.team_name is null and tm.team is null))  order by tm.team desc) H  on A.value = H.team ";
			   querySql+="  full join (select tm.team, count(1) G_N  from (   select d2.apply_team as team,  '' as spare1,  t.start_date as actual_start_date,  t.bsflag,  clr.receive_no as prepare_no,  t.labor_id as employee_id,  d3.coding_name team_name  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2  on t.labor_deploy_id =  d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l  on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id  left join bgp_comm_human_receive_labor clr  on clr.deploy_detail_id =  d2.deploy_detail_id  and clr.bsflag = '0'  where t.bsflag = '0'  and t.project_info_no =  '"+projectInfoNo+"' ) tm  left join comm_coding_sort_detail d1  on tm.team = d1.coding_code_id  group by rollup(tm.team, tm.team_name)  having(tm.team_name is not null or (tm.team_name is null and tm.team is null))  order by tm.team desc) G  on A.value = G.team ";
			   querySql+="   full join (select tm.team, count(1) K_N  from (   select d2.apply_team as team,  '' as spare1,  t.start_date as actual_start_date,  t.bsflag,  clr.receive_no as prepare_no,  t.labor_id as employee_id,  d3.coding_name team_name  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2  on t.labor_deploy_id =  d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l  on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id  left join bgp_comm_human_receive_labor clr  on clr.deploy_detail_id =  d2.deploy_detail_id  and clr.bsflag = '0'  where t.bsflag = '0'  and t.end_date is not null    and t.project_info_no =  '"+projectInfoNo+"'  ) tm  left join comm_coding_sort_detail d1  on tm.team = d1.coding_code_id  group by rollup(tm.team, tm.team_name)  having(tm.team_name is not null or (tm.team_name is null and tm.team is null))  order by tm.team desc) K  on A.value = K.team    GROUP BY A.LABELS  ORDER BY A.LABELS DESC  ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length ; i++) {
				 
				var tr = document.getElementById("projectMan").insertRow();		
				
        		if(i % 2 == 1){  
        			tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				
        		var team = datas[i].team;
        		 
 				var td = tr.insertCell(0);
 				td.innerHTML = datas[i].labels; //班组
 				
 				var td = tr.insertCell(1);
 				td.innerHTML = datas[i].b; //计划人数
 				
 				var td = tr.insertCell(2);//调配人数
 				td.innerHTML = datas[i].c;
 				
 				var td = tr.insertCell(3);//接收人数(正式工)
 				td.innerHTML = datas[i].zjs;
 				
 				var td = tr.insertCell(4);//返还人数
 				td.innerHTML = datas[i].zfh;
        			
 				var td = tr.insertCell(5);//接收人数(临时工)
 				td.innerHTML = datas[i].ljs;
 				
 				var td = tr.insertCell(6);//返还人数
 				td.innerHTML = datas[i].lfh;
 				
		    	  
	        
			}
		}	
		
}
 
 
 function getHumanList(team,postSort){
	 popWindow('<%=contextPath%>/rm/em/humanChart/humanChart18-3.jsp?projectInfoNo=<%=projectInfoNo%>&team='+team+'&postSort='+postSort,'800:700');
	 
 }
 
 function getTableListData(){
		
		var querySql = "select d.coding_name label,count(p.EMPLOYEE_ID) value from view_human_project_relation p left join comm_coding_sort_detail d on p.EMPLOYEE_EDUCATION_LEVEL=d.coding_code_id  where  p.PROJECT_INFO_NO='"+projectInfoNo+"'  and p.actual_start_date is not null    and p.employee_gz in ('0110000019000000001','0110000019000000002') and p.EMPLOYEE_EDUCATION_LEVEL is not null group by d.coding_name";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		var querySql1 = "select t.age label,count(t.age) value  from (select case when t.age<=25 then '25以下' when t.age>25 and t.age<=30 then '26-30岁' when t.age>30 and t.age<=35 then '31-35岁' when t.age>35 and t.age<=40 then '35-40岁' when t.age>40 and t.age<=45 then '40-45岁' when t.age>45 and t.age<=50 then '46-50岁'  when t.age>50 and t.age<=55 then '50-55岁' when t.age>55 and t.age<=60 then '56-60岁'  else '61岁以上' end age   from ( select to_char(sysdate,'yyyy')- to_char(p.EMPLOYEE_BIRTH_DATE,'yyyy') as age from view_human_project_relation p  left join comm_coding_sort_detail d on p.WORK_POST=d.coding_code_id  where  p.PROJECT_INFO_NO='"+projectInfoNo+"' and p.actual_start_date is not null   and p.employee_gz in ('0110000019000000001','0110000019000000002') ) t) t group by t.age";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length ; i++) {
				
			var tr = document.getElementById("educationMap").insertRow();		
				
           	if(i % 2 == 1){  
           		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				
				var td = tr.insertCell(0);
				td.innerHTML = datas[i].label;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].value;				
			}
		}	
		
		if(datas1 != null){
			for (var i = 0; i< queryRet1.datas.length ; i++) {
				
			var tr = document.getElementById("ageMap").insertRow();		
				
           	if(i % 2 == 1){  
           		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				
				var td = tr.insertCell(0);
				td.innerHTML = datas1[i].label;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas1[i].value;				
			}
		}
 }
 
 
 function changeTeam(){
	 
     var chartReference = FusionCharts("myChartId2");     
     var s_team = document.getElementsByName("s_team")[0].value;
     chartReference.setXMLUrl("<%=contextPath%>/rm/em/getChart18.srq?projectInfoNo=<%=projectInfoNo%>&team="+s_team);
 }
</script>  
<script type="text/javascript">
	/**/function frameSize() {

		var width = $(window).width() - 256;
		$("#tongyong_box_content_left_1").css("width", width);

	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	})
</script>
</html>

