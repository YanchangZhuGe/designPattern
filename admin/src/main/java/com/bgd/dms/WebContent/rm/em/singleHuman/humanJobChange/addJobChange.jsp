<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%>  
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
  
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String job_ids =  request.getParameter("job_ids");	 
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

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData();getApplyTeam();">
		 <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:100%">
			 <table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
			 	<tr>
			 	<td  class="inquire_item4">作业组：</td>
			 	<td class="inquire_form4">
			 	<input type="hidden" id="jobId" name="jobId" value=""/>
			 	<input type="text"   value="" id="jobName"  name="jobName" class='input_width'  ></input>  
			 	</td>
			 	<td class="inquire_item4"> </td> 
			 	<td class="inquire_form4"> </td>	
			 	</tr> 
			 </table>  
		 </div>  
 
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
			    <td class="ali_cdn_name">班组</td>
			    <td class="ali_cdn_input"><select class="select_width" id="s_apply_team" name="s_apply_team" onchange="getPost()"></select>
			     
				<input type='hidden' id="checkall" name="checkall" value="0"/>
				<input type='hidden' id="szButton" name="szButton" value=""/> 
		    
			    </td>
			    <td class="ali_cdn_name">岗位</td>
			    <td class="ali_cdn_input"><select class="select_width"  id="s_post" name="s_post" ></select></td>
			    
			    <td class="ali_cdn_name">用工性质</td>
			    <td class="ali_cdn_input">
				    <select id="xzV"  name="xzV" style="width:100px;">
					<option value="" >请选择</option>
					<option value="1">正式工</option>
					<option value="0">临时工</option>
					</select>
			    </td>
			    
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="toSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			    <auth:ListButton functionId="" css="bc" event="onclick='toSave()'" title="保存"></auth:ListButton>
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
			      <td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{pk_ids}-{xz_type}' id='rdo_entity_id'/>" >
					<input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"/></td>
			      <td class="bt_info_odd" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{employee_gz_name}">用工性质</td>
			      <td class="bt_info_odd" exp="{employee_cd}">员工编号</td>
			      <td class="bt_info_even" exp="{employee_name}">员工姓名</td>
			      <td class="bt_info_odd" exp="{team_name}">班组</td>
			      <td class="bt_info_even" exp="{work_post_name}">岗位</td>
			      <td class="bt_info_odd" exp="{plan_start_date}">预计进入项目时间</td>
			      <td class="bt_info_even" exp="{plan_end_date}">预计离开项目时间</td>
			      <td class="bt_info_odd" exp="{actual_start_date}">实际进入项目时间</td>
			      <td class="bt_info_even" exp="{days}">预计项目天数</td>
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
		 
</div>
</body>
 
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var job_ids="<%=job_ids%>";
	if(job_ids !='' && job_ids !='null'){
			var querySql = "   select  t.job_id,t.job_name,t.project_info_no   from  bgp_comm_human_job  t   where t.bsflag='0' and t.project_info_no='<%=projectInfoNo%>'  and t.job_id='"+job_ids+"'  ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
			if(queryRet.returnCode=='0'){
				var datas = queryRet.datas;
				if(datas != null && datas!=""){	
					 document.getElementsByName("jobId")[0].value=datas[0].job_id; 
					 document.getElementsByName("jobName")[0].value=datas[0].job_name; 
					 
				}					
				
	    	 }	
	}
	
	function refreshData(){	 
		var headChx = document.getElementById("headChxBox");	
		head_chx_box_changed(headChx);
 
		cruConfig.queryStr = "select t.*  from (select distinct t.EMPLOYEE_ID,t.job_id,t.pk_ids, case  when   t.employee_cd is not null then '1'  when   t.employee_cd is null then  '0'  end xz_type,    t.EMPLOYEE_NAME,  nvl(t.employee_cd,t.id_code) employee_cd,  t.id_code,   t.ACTUAL_START_DATE,  t.ACTUAL_END_DATE,  t.plan_start_date,  to_char( nvl(t.plan_end_date, sysdate),'yyyy-MM-dd') plan_end_date,  round( case when nvl(t.plan_end_date, sysdate) - t.plan_start_date > 0 then nvl(t.plan_end_date, sysdate) - t.plan_start_date  -(-1) else 0 end ) days,  t.TEAM,  t.WORK_POST,  d1.coding_name      team_name,  d2.coding_name      work_post_name,  t.EMPLOYEE_GZ,  d3.coding_name      employee_gz_name  from view_human_project_relation t  left join comm_coding_sort_detail d1  on t.team = d1.coding_code_id  and d1.coding_mnemonic_id = '<%=projectType%>'  left join comm_coding_sort_detail d2  on t.work_post = d2.coding_code_id  and d2.coding_mnemonic_id = '<%=projectType%>'  left join comm_coding_sort_detail d3  on t.EMPLOYEE_GZ = d3.coding_code_id  where t.project_info_no = '<%=projectInfoNo%>'  and t.actual_start_date is not null  and t.ACTUAL_END_DATE is null and t.job_id is null  order by t.EMPLOYEE_GZ, t.EMPLOYEE_NAME) t  where 1 = 1 ";
     	cruConfig.currentPageUrl = "/rm/em/singleHuman/humanJobChange/addJobChange.jsp";
		queryData(1); 
		 
	}
 
	function toSearch(){ 
		var xzV = document.getElementById("xzV").value; 
		var s_apply_team = document.getElementById("s_apply_team").value;
		var s_post = document.getElementById("s_post").value;
		
		var str = "  1=1 ";
		if(xzV!=''){
			str += " and xz_type = '"+xzV+"' ";
		}
		if(s_apply_team != ''){
			str+=" and team='"+s_apply_team+"'";
		}
		if(s_post != ''){
			str+=" and work_post='"+s_post+"'";
		}
		cruConfig.cdtStr = str;
		refreshData();

	}

	function clearQueryText(){ 
		document.getElementById("xzV").value="";
		document.getElementById("s_apply_team").value="";
    	var selectObj = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);
	}
 
    
	function toSave(){  
		
		var jobName = document.getElementById("jobName").value;
		var jobId = document.getElementById("jobId").value;
		if (jobName ==''){
			alert("请填写作业组名称!");
			return; 
		}
		
		   var querySql = "   select  t.job_id,t.job_name,t.project_info_no   from  bgp_comm_human_job  t   where t.bsflag='0' and t.job_name='"+jobName.replace(/[ ]/g,"")+"' and t.project_info_no='<%=projectInfoNo%>'   ";
		   var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);

			if(queryRet.returnCode=='0'){
				var datas = queryRet.datas;
				if(datas != null && datas!=""){	 
						var jobIds=datas[0].job_id; 
						if(jobId!= "" && jobId!=null ){
							if(jobIds !=jobId ){
								alert("作业组名称已存在,请输入其他名称!");
								 document.getElementsByName("jobName")[0].value=""; 
								 return; 	
							} 
						}else{ 
							alert("作业组名称已存在,请输入其他名称!");
							 document.getElementsByName("jobName")[0].value=""; 
							 return; 	
							
						}
				}					
				
	    	 }		 
		
		var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
		var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_JOB&JCDP_TABLE_ID='+jobId+'&job_name='+jobName
		+'&creator=<%=userName%>&updator=<%=userName%>&create_date=<%=curDate%>&modifi_date=<%=curDate%>&project_info_no=<%=projectInfoNo%>&bsflag=0';
	 
		var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
		var job_id=retObject.entity_id; //获得 主表id 			
	 
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
 		
		var tempIds = ids.split(",");		
		var detailNoZs = "";
		var detailNoLs = ""; 
		var xzType = "";		
		for(var i=0;i<tempIds.length;i++){			
			
			xzType=tempIds[i].split("-")[1] ;
			if(xzType == '1'){
				detailNoZs = detailNoZs + "," + "'" + tempIds[i].split("-")[0] + "'";
			}else if (xzType == '0'){
				detailNoLs = detailNoLs + "," + "'" + tempIds[i].split("-")[0] + "'";
			}
			  	
		}
		var dZs=detailNoZs.substr(1);
		var dLs=detailNoLs.substr(1);
 
		if(dZs == "" ){
			dZs= "'1'";
		}
		if(dLs == ""){
			dLs= "'1'";
		}

		var sql1 = "update bgp_human_prepare_human_detail t set t.job_id='"+job_id+"'   where t.human_detail_no in ("+dZs+") ";
	 	var sql2 = "update bgp_comm_human_labor_deploy t set t.job_id='"+job_id+"'  where t.labor_deploy_id in ("+dLs+") ";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var retObject = syncRequest('Post',path,"deleteSql="+sql1+"&ids="+dZs);
	    var retObject = syncRequest('Post',path,"deleteSql="+sql2+"&ids="+dLs);
		top.frames('list').refreshData();
		top.frames('list').loadDataDetail(job_id);
		newClose();
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
	
	
    function getApplyTeam(){
    	var selectObj = document.getElementById("s_apply_team"); 
    	document.getElementById("s_apply_team").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);

    	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","");	
    	for(var i=0;i<applyTeamList.detailInfo.length;i++){
    		var templateMap = applyTeamList.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    	}   	
    	var selectObj1 = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
    	selectObj1.add(new Option('请选择',""),0);
    }

    function getPost(){
        var applyTeam = "applyTeam="+document.getElementById("s_apply_team").value;   
    	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	

    	var selectObj = document.getElementById("s_post");
    	document.getElementById("s_post").innerHTML="";
    	selectObj.add(new Option('请选择',""),0);
    	if(applyPost.detailInfo!=null){
    		for(var i=0;i<applyPost.detailInfo.length;i++){
    			var templateMap = applyPost.detailInfo[i];
    			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
    		}
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
	

</script>
</html>