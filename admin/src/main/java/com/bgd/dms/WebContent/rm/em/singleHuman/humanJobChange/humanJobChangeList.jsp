<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	
	String projectInfoNo = user.getProjectInfoNo();
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
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/rm/em/singleHuman/humanAttendance/Calendar1.js"></script>
  <title>作业组信息</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">作业组</td>
		 	    <td class="ali_cdn_input"><input id="s_job_name" class="input_width"  name="s_job_name" type="text"   /></td>
			    <td class="ali_query">
			    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		       </td>
		       <td class="ali_query">
			    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
		    	</td>
			    <td>&nbsp;</td>
			    <td> 		
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    </td>		  
			    
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{job_id}' id='rdo_entity_id_{job_id}'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{job_name}"  isExport='Hide' >作业组</td> 
			      <td class="bt_info_odd" exp="{nn}" isExport='Hide' >合计</td>
			      <td class="bt_info_even" exp="{n2}" isExport='Hide' >合同化/市场化</td>
			      <td class="bt_info_odd" exp="{n3}" isExport='Hide' >临时-固定期限合同</td>			 
			      <td class="bt_info_even" exp="{n4}" isExport='Hide' >完成工作任务</td>			 
 			      <td class="bt_info_odd" exp="{n5}" isExport='Hide' >非全日制</td>
			      <td class="bt_info_even" exp="{n6}" isExport='Hide' >劳务用工</td>			 
 			      <td class="bt_info_odd" exp="{n7}" isExport='Hide' >再就业人员</td>
 			      
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">人员信息</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">备注</a></li>

			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">		
					<div style="overflow:auto">
			      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  	<tr align="right">
					  		<td class="ali_cdn_name" >作业组:&nbsp;&nbsp;</td>
					  		<td class="ali_cdn_input" >
					  		<input type="hidden" id="jobId" name="jobId" value="" />
						 	<input type="text"   value="" id="jobName"  name="jobName"  style="width:250px;" ></input>  
						 	</td> <td>&nbsp;</td>
						 	<auth:ListButton functionId="" css="zj" event="onclick='toDRRY()'" title="增加"></auth:ListButton>
						 	<auth:ListButton functionId="" css="bc" event="onclick='toSavePk()'" title="修改作业组"></auth:ListButton>
						</tr>
					  </table>
				  </div>
			 
				   <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="humTableInfo">
				    
		          	<tr > 	
		          	    <TD  class="bt_info_even"  width="12%">用工性质</TD>
		          		<TD  class="bt_info_odd" width="12%" >员工编号</TD>	          		
		          	    <TD  class="bt_info_even"  width="12%">员工姓名</TD>
		          		<TD  class="bt_info_odd" width="12%" >岗位</TD>	          		
		          	    <TD  class="bt_info_even"  width="12%">预计进入项目时间</TD>
		          		<TD  class="bt_info_odd" width="12%" >预计离开项目时间</TD>
		          	    <TD  class="bt_info_even"  width="12%">实际进入项目时间</TD>
		          		<TD  class="bt_info_odd" width="9%" >预计项目天数</TD>
		          		
		          		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="0" />
		          		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />	
		          		<input type="hidden" id="lineNum" value="0"/>
		          		<TD class="bt_info_even" width="7%">操作</TD>
		          	</tr>
		          		 
		          </table>	 
		          
				</div>
				<div id="tab_box_content1" name="tab_box_content1"  class="tab_box_content" style="display:none;">					
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
	var projectType="<%=projectType%>";
 
	function refreshData(){ 
     	cruConfig.queryStr = "  select *  from ( select distinct   t.job_id,  nvl(t.job_name, '合计') job_name,  count(1) nn,  sum(case  when  t.EMPLOYEE_GZ = '0110000019000000001' then  1  else  0  end) +  sum(case  when  t.EMPLOYEE_GZ = '0110000019000000002' then  1  else  0  end)  n2,   sum(case  when  t.EMPLOYEE_GZ = '0110000059000000005' then  1  else  0  end) n3,  sum(case  when  t.EMPLOYEE_GZ = '110000059000000006' then  1  else  0  end) n4,  sum(case  when  t.EMPLOYEE_GZ = '0110000059000000002' then  1  else  0  end) n5  ,  sum(case  when  t.EMPLOYEE_GZ = '0110000059000000003' then  1  else  0  end) n6,  sum(case  when  t.EMPLOYEE_GZ = '0110000059000000001' then  1  else  0  end) n7    from (select distinct t.EMPLOYEE_ID,t.JOB_ID,chj.job_name,    t.EMPLOYEE_GZ   from view_human_project_relation t  left join BGP_COMM_HUMAN_JOB chj  on chj.job_id=t.JOB_ID and chj.bsflag='0' and  chj.project_info_no = '<%=projectInfoNo%>'     where t.project_info_no = '<%=projectInfoNo%>'   and t.actual_start_date is not null  and t.ACTUAL_END_DATE is null  order by t.EMPLOYEE_GZ, t.EMPLOYEE_NAME) t  where 1 = 1        group by rollup( t.job_id,t.job_name)   having(t.job_name is not null or (t.job_name is not  null and t.job_id is not  null))  union all  select   t.job_id, t.job_name, 0 nn,0 n2,0 n3,0 n4, 0 n5, 0 n6, 0 n7 from BGP_COMM_HUMAN_JOB t  where   t.bsflag='0'  and t.JOB_ID  not in (  select distinct   t.JOB_ID         from view_human_project_relation t          left  join BGP_COMM_HUMAN_JOB chj    on chj.job_id  = t.JOB_ID       and chj.bsflag = '0'    and chj.project_info_no = '<%=projectInfoNo%>'       where t.project_info_no = '<%=projectInfoNo%>'        and t.actual_start_date is not null     and t.ACTUAL_END_DATE is null   and  chj.job_id is not null )and  t.PROJECT_INFO_NO ='<%=projectInfoNo%>' ) c  ";
     	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanAttendance/humanAttendanceList.jsp";
		queryData(1); 
	}
	function toAdd(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/humanJobChange/addJobChange.jsp?','880:650');
		
	}
	 
	  function toDRRY(){ 
			ids = getSelectedValue();
		    if(ids==''){ alert("请先选中一条记录!");
		     return;
		    } 
			popWindow('<%=contextPath%>/rm/em/singleHuman/humanJobChange/addJobChange.jsp?job_ids='+ids,'880:650');
	   }
	    
	  
	  function toSavePk(){ 
			ids = getSelectedValue();
		    if(ids==''){ alert("请先选中一条记录!");
		     return;
		    } 
		    var jobName = document.getElementById("jobName").value; 
		    if(jobName==''){ alert("作业组不能为空!");
		     return;
		    } 
		    
			   var querySql = "   select  t.job_id,t.job_name,t.project_info_no   from  bgp_comm_human_job  t   where t.bsflag='0' and t.project_info_no = '<%=projectInfoNo%>'   and t.job_name='"+jobName.replace(/[ ]/g,"")+"'  ";
			   var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);

				if(queryRet.returnCode=='0'){
					var datas = queryRet.datas;
					if(datas != null && datas!=""){	
						var jobIds=datas[0].job_id; 
						if(jobIds !=ids ){
							alert("作业组名称已存在,请输入其他名称!");
							 document.getElementsByName("jobName")[0].value=""; 
							 return; 	
						}
									 
					}					
					
		    	 }	
				
		    var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
			var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_JOB&JCDP_TABLE_ID='+ids+'&job_name='+jobName
			+'&updator=<%=userName%>&modifi_date=<%=curDate%>&bsflag=0'; 
			var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
			refreshData();
			loadDataDetail(ids);
	   }
	  
	  function toDelete(){ 
			ids = getSelectedValue();
		    if(ids==''){ alert("请先选中一条记录!");
		     return;
		    } 
		 	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		    var sql1 = " update bgp_human_prepare_human_detail t set t.job_id=''   where t.job_id ='"+ids+"' ";
		 	var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+ids); 
		    var sql2 = " update bgp_comm_human_labor_deploy t set t.job_id=''  where t.job_id = '"+ids+"' ";
			var retObject1 = syncRequest('Post',path,"deleteSql="+sql2+"&ids="+ids); 
			var sql3 = " update BGP_COMM_HUMAN_JOB t set t.bsflag='1'   where t.job_id ='"+ids+"' ";
			var retObject1 = syncRequest('Post',path,"deleteSql="+sql3+"&ids="+ids);
			refreshData();
	   }
	  
	  
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function simpleSearch(){
		
		var s_job_name = document.getElementById("s_job_name").value; 
	 		
		var str = " 1=1 ";
		if(s_job_name!=''){
			str += " and job_name like '%"+s_job_name+"%' ";
		}
	    cruConfig.cdtStr = str;
		refreshData();

	}
 
	function clearQueryText(){ 
		 document.getElementById("s_job_name").value=""; 
 
	     cruConfig.cdtStr = "";
	}
	
    function loadDataDetail(ids){   		
    	   document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
   		   var querySql = "   select  t.job_id,t.job_name,t.project_info_no   from  bgp_comm_human_job  t   where t.bsflag='0' and t.job_id='"+ids+"'  ";
		   var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);

			if(queryRet.returnCode=='0'){
				var datas = queryRet.datas;
				if(datas != null && datas!=""){	
					 document.getElementsByName("jobId")[0].value=datas[0].job_id; 
					 document.getElementsByName("jobName")[0].value=datas[0].job_name; 
					 
				}					
				
	    	 }		
	
			
			 var querySql1="";
			 var queryRet1=null;
			 var datas1 =null;
			 deleteTableTr("humTableInfo");
	    	 document.getElementById("lineNum").value="0";	
			   querySql1 = "  select distinct t.EMPLOYEE_ID,t.job_id,t.pk_ids, case  when   t.employee_cd is not null then '1'  when   t.employee_cd is null then  '0'  end xz_type,    t.EMPLOYEE_NAME,  nvl(t.employee_cd,t.id_code) employee_cd,  t.id_code,   t.ACTUAL_START_DATE,  t.ACTUAL_END_DATE,  t.plan_start_date,  to_char( nvl(t.plan_end_date, sysdate),'yyyy-MM-dd') plan_end_date,  round( case when nvl(t.plan_end_date, sysdate) - t.plan_start_date > 0 then nvl(t.plan_end_date, sysdate) - t.plan_start_date  -(-1) else 0 end ) days,  t.TEAM,  t.WORK_POST,  d1.coding_name      team_name,  d2.coding_name      work_post_name,  t.EMPLOYEE_GZ,  d3.coding_name      employee_gz_name  from view_human_project_relation t  left join comm_coding_sort_detail d1  on t.team = d1.coding_code_id  and d1.coding_mnemonic_id = '<%=projectType%>'  left join comm_coding_sort_detail d2  on t.work_post = d2.coding_code_id  and d2.coding_mnemonic_id = '<%=projectType%>'  left join comm_coding_sort_detail d3  on t.EMPLOYEE_GZ = d3.coding_code_id  where t.project_info_no = '<%=projectInfoNo%>'  and t.actual_start_date is not null  and t.ACTUAL_END_DATE is null and t.job_id ='"+ids+"'  order by t.EMPLOYEE_GZ, t.EMPLOYEE_NAME  ";
			   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
				if(queryRet1.returnCode=='0'){
				  datas1 = queryRet1.datas;	 
					if(datas1 != null && datas1 != ''){				 
							for(var i = 0; i<datas1.length; i++){
					       addLine1(datas1[i].xz_type,datas1[i].pk_ids,datas1[i].employee_gz_name,datas1[i].employee_cd,datas1[i].employee_name,datas1[i].work_post_name,datas1[i].plan_start_date,datas1[i].plan_end_date,datas1[i].actual_start_date,datas1[i].days,datas1[i].job_id);
						}
						
					}
			    }	
				
				
 
    }
    
  
 	function addLine1(xz_types,pk_ids,employee_gz_names,employee_cds,employee_names,work_post_names,plan_start_dates,plan_end_dates,actual_start_dates,dayss,job_ids){
 
		var xz_type = "";
		var pk_id = "";
		var employee_gz_name = "";
		var employee_cd = "";
		var employee_name ="";
		var work_post_name ="";
		var plan_start_date ="";
		var plan_end_date =""; 
		var actual_start_date = "";
		var days = "";
		var job_id = "";
		 

		if(xz_types != null && xz_types != ""){
			xz_type=xz_types;
		}
		if(pk_ids != null && pk_ids != ""){
			pk_id=pk_ids;
		}
		if(employee_gz_names != null && employee_gz_names != ""){
			employee_gz_name=employee_gz_names;
		}
		
		if(employee_cds != null && employee_cds != ""){
			employee_cd=employee_cds;
		}
		if(employee_names != null && employee_names != ""){
			employee_name=employee_names;
		}
	 
		if(work_post_names != null && work_post_names != ""){
			work_post_name=work_post_names;
		}
		
		
		if(plan_start_dates != null && plan_start_dates != ""){
			plan_start_date=plan_start_dates;
		}
		if(plan_end_dates != null && plan_end_dates != ""){
			plan_end_date=plan_end_dates;
		}
		if(actual_start_dates != null && actual_start_dates != ""){
			actual_start_date=actual_start_dates;
		}
		
		  
		if(dayss != null && dayss != ""){
			days=dayss;
		}
		
		if(job_ids != null && job_ids != ""){
			job_id=job_ids;
		}
	 
		 
		var rowNum = document.getElementById("lineNum").value;	
		
		var tr = document.getElementById("humTableInfo").insertRow();
		
		tr.align="center";		
 
	  	if(rowNum % 2 == 1){  
	  		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}	
		tr.id = "row_" + rowNum + "_";   
 
	  		
		tr.insertCell().innerHTML = '<input type="hidden"  name="xz_type' + '_' + rowNum + '" value="'+xz_type+'"/>'+'<input type="text" style="width:120px;" class="input_width" name="employee_gz_name' + '_' + rowNum + '" value="'+employee_gz_name+'" readonly="readonly"  />';
		tr.insertCell().innerHTML = '<input type="hidden"  name="job_id' + '_' + rowNum + '" value="'+job_id+'"/>'+'<input type="hidden"  name="pk_id' + '_' + rowNum + '" value="'+pk_id+'"/>'+'<input type="text" style="width:120px;" class="input_width" name="employee_cd' + '_' + rowNum + '" value="'+employee_cd+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:120px;" class="input_width" name="employee_name' + '_' + rowNum + '" value="'+employee_name+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:120px;" class="input_width" name="work_post_name' + '_' + rowNum + '" value="'+work_post_name+'"  readonly="readonly" />';
		 
		tr.insertCell().innerHTML ='<input type="text" style="width:120px;" class="input_width" name="plan_start_date' + '_' + rowNum + '" value="'+plan_start_date+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:120px;" class="input_width" name="plan_end_date' + '_' + rowNum + '" value="'+plan_end_date+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:120px;" class="input_width" name="actual_start_date' + '_' + rowNum + '" value="'+actual_start_date+'"  readonly="readonly" />';
		tr.insertCell().innerHTML ='<input type="text" style="width:90px;" class="input_width" name="days' + '_' + rowNum + '" value="'+days+'"  readonly="readonly" />';
		 	
		var td = tr.insertCell(); 
		td.style.display = "";
		td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;			 
		
	}
 	
 	
 	 function deleteLine(lineId){		
			var rowNum = lineId.split('_')[1];
			var line = document.getElementById(lineId);		
 
			var xz_type = document.getElementsByName("xz_type_"+rowNum)[0].value;
			var pk_id = document.getElementsByName("pk_id_"+rowNum)[0].value;
			var job_id = document.getElementsByName("job_id_"+rowNum)[0].value;
			
		 	var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			if(xz_type!=""){
				line.style.display = 'none';
				if(xz_type =='1'){ //正式工清除 与作业组的关系
					 var sql1 = "update bgp_human_prepare_human_detail t set t.job_id=''   where t.human_detail_no ='"+pk_id+"' ";
				 	 var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+pk_id);
					//deleteEntities(" update bgp_human_prepare_human_detail t set t.job_id=''   where t.human_detail_no ='"+pk_id+"'");
				    
				}else if(xz_type =='0'){ //临时工清除 与作业组的关系
				      var sql2 = "update bgp_comm_human_labor_deploy t set t.job_id=''  where t.labor_deploy_id = '"+pk_id+"' ";
					  var retObject = syncRequest('Post',path,"deleteSql="+sql2+"&ids="+pk_id);
					// deleteEntities(" update bgp_comm_human_labor_deploy t set t.job_id=''  where t.labor_deploy_id = '"+pk_id+"' ");
				} 
				refreshData();
				loadDataDetail(job_id);
			}else{
				line.parentNode.removeChild(line);
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