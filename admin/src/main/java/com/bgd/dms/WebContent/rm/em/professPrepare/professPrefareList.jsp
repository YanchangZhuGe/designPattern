<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId=user.getEmpId();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String curDate = df.format(new Date()); 

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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

  <title>项目页面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td class="ali_cdn_name">项目名称</td>
			    <td   width="20%" ><input class="input_width" id="s_project_info_no" name="s_project_info_no" type="text"  />
				<input name="s_project_name" id="s_project_name" class="input_width" value="" type="hidden"   />   
  			    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   
  			     </td>
			    
			   
			    <td class="ali_cdn_name">调配状态</td>
			    <td  width="20%">
			    <select name="s_proc_status" id="s_proc_status" class="select_width" >
			    <option value="">请选择</option>
			    <option value="0" selected >待调配</option>
			    <option value="1">调配中</option>
			    <option value="2">已调配</option>    
			    </select>			     
			    </td>
			    
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td width="25%" >&nbsp;</td>
  				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
  				<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton> 
  				<auth:ListButton functionId="F_HUMAN_005" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>				
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" style="height:100%">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			      <td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{professNo},{prepareNo},{prepareStatus},{preFlag},{projectType},{flowName}' id='rdo_entity_id_{profess_no}'  onclick='chooseOne(this);'  />" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{projectName}">项目名称</td>
			      <td class="bt_info_odd" exp="{prepareStatusName}">调配状态</td>
			      <td class="bt_info_even" exp="{flowName}">审核状态</td>	
			      <td class="bt_info_even" exp="{applyNo}">申请单号</td>
			      <td class="bt_info_odd" exp="{applicantName}">申请人</td>
			      <td class="bt_info_even" exp="{applicantOrgName}">申请单位</td>
			      <td class="bt_info_odd" exp="{prepareId}">调配单号</td>
			      <td class="bt_info_even" exp="{deployOrgName}">调配单位</td>
			      <td class="bt_info_odd" exp="{deployDate}">调配时间</td>
			  
			      <td class="bt_info_odd" exp="{applyDate}">提交时间</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">调配岗位</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">调配人员</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">审批流程</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="postDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>班组</td>
				            <td>岗位</td>		
				            <td>调配人数</td>
				            <td>计划进入项目时间</td>			
				            <td>计划离开项目时间</td>          
				            <td>预计在项目天数</td>
				            <td>年龄</td>			
				            <td>工作年限</td> 
				            <td>文化程度</td>  
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table id="humanDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>班组</td>
				            <td>岗位</td>		
				            <td>姓名</td>	
				            <td>预计进入项目时间</td> 
				            <td>预计离开项目时间</td> 
				            <td>预计在项目天数</td>		
				            <td>实际进入项目时间</td>		
				            <td>实际离开项目时间</td>		
				            <td>实际在项目天数</td>		
				        </tr>            
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content4" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>			
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
	cruConfig.queryService = "HumanCommInfoSrv";
	cruConfig.queryOp = "searchProfessPrepare";
 
	function toAdd(){
		
//		ids = getSelIds('rdo_entity_id');
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
	    var tempa = ids.split(',');		    
	    var prepare_status = tempa[2];
	    var project_type= tempa[4]; 
	    
	    if(prepare_status == 1 ){
	        if(!window.confirm("该调配单已处于调配中，如果进行新的调配，请选择确定，否则，请取消!")) {
	    		return;
	    	}		    	
	    }
	    if(prepare_status == 2 ){
	        if(!window.confirm("该调配单已调配，如果进行新的调配，请选择确定，否则，请取消!")) {
	    		return;
	    	}	
	    }
	    
		popWindow('<%=contextPath%>/rm/em/toProfessionPrepareEdit.srq?id='+ids.split(",")[0]+'&project_type='+project_type,'1000:800');
		
	}
	
	//选择项目
	function selectTeam(){

	    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("s_project_info_no").value = checkStr[1];
		        document.getElementById("s_project_name").value = checkStr[0];
	    }
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

    
	
	function toEdit(){
		ids = getSelectedValue();

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
	    var tempa = ids.split(',');		
	    var requirement_no =  tempa[0];    
	    var prepare_no = tempa[1];		    		  
	    var prepare_status =  tempa[2];
	    var project_type= tempa[4]; 
	    var flowName= tempa[5]; 
	    if (flowName !='审批不通过'){
		    if(prepare_status == 2 ){
		        alert("该调配单已提交不能修改!");
		    	return;
		    }	    
	    }
		if(prepare_status == 0 ){
	        alert("该调配单未调配,请先调配!");
	    	return;
	    }

		popWindow('<%=contextPath%>/rm/em/toProfessionPrepareEdit.srq?update=true&id='+ids.split(",")[0]+'&prepareNo='+ids.split(",")[1]+'&project_type='+project_type,'1000:800');
		
	}
	
	function toSubmit(){
		
		ids = getSelectedValue();

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
	    var tempa = ids.split(',');		
	    var requirement_no =  tempa[0];    
	    var prepare_no = tempa[1];		    		  
	    var prepare_status =  tempa[2];
	    var pre_flag =  tempa[3];
	    var flowName= tempa[5]; 
	    if (flowName !='审批不通过'){
		    if(prepare_status == 2){
		    	alert("该调配已提交,不允许再次提交");
		    	return;
		    }
	    }
		if(prepare_status == 0 ){
	        alert("该调配单未调配,请先调配!");
	    	return;
	    }

		if (!window.confirm("确认要提交吗?")) {
			return;
		}
		var sql = "update bgp_human_prepare t set t.prepare_status='2' where t.prepare_no ='"+ids.split(",")[1]+"'";
		var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
		var params = "sql="+sql;
		params += "&ids="+ids.split(",")[1];
		var retObject = syncRequest('Post',path,params);
		
 
		var querySql1 = "select rownum ,p.* from (select distinct t.human_detail_no,ehr.employee_hr_id,t.team, t.work_post, t.employee_id, e.employee_name, t.plan_start_date, t.plan_end_date,(t.plan_end_date- t.plan_start_date + 1) plan_days,(t.actual_end_date- t.actual_start_date + 1) actual_days, t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name, t.actual_end_date,t.spare1,t.notes from bgp_human_prepare_human_detail t  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id  left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'  left join   comm_human_employee_hr ehr on ehr.employee_id = e.employee_id  and ehr.bsflag='0'  where r.prepare_no='"+prepare_no+"' and t.bsflag='0'  union all select distinct     t.labor_deploy_id as human_detail_no ,  t.labor_id as employee_hr_id,d2.apply_team as team, d2.post as work_post ,  t.labor_id as employee_id,   l.employee_name,   t.start_date as plan_start_date ,  t.spare4 as  plan_end_date,  (t.spare4 - t.start_date + 1) plan_days,    (t.end_date -  t.actual_start_date + 1) actual_days,    t.actual_start_date,  d3.coding_name team_name,  d4.coding_name work_post_name,    t.end_date as actual_end_date,   t.spare1,  t.notes        from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2     on t.labor_deploy_id = d2.labor_deploy_id    and d2.bsflag = '0'   left join bgp_comm_human_labor l     on t.labor_id = l.labor_id    left join comm_coding_sort_detail d3     on d2.apply_team = d3.coding_code_id   left join comm_coding_sort_detail d4     on d2.post = d4.coding_code_id    where t.bsflag = '0'  and   t.spare1= '"+prepare_no+"'  ) p ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		if(datas1 != null){	 
		     for (var i = 0; i< queryRet1.datas.length; i++) {    
 				var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
   				var submitStr = 'JCDP_TABLE_NAME=COMM_HUMAN_EMPLOYEE_HR&JCDP_TABLE_ID='+datas1[i].employee_hr_id +'&deploy_status=2&person_status=1&modifi_date=<%=curDate%>';
   			    syncRequest('Post',paths,encodeURI(encodeURI(submitStr)));  //提交人员调配单是同时更新 人员表中的 调配状态“已调配”		
   				var submitStrL = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_LABOR&JCDP_TABLE_ID='+datas1[i].employee_hr_id +'&spare1=2&if_project=1&modifi_date=<%=curDate%>';
   			    syncRequest('Post',paths,encodeURI(encodeURI(submitStrL)));  //提交人员调配单是同时更新 临时工表中的 调配状态“已调配”		
 
		     } 
		}
	 
//		if(pre_flag == 'no'){
//			submitProcessInfo();
//		}
		submitProcessInfo();
		refreshData();
	}
	
	function refreshData(){

//		cruConfig.queryStr = "select p.profess_no,p.project_info_no, p.apply_no,p.apply_state,p.applicant_id,e.employee_name, p.apply_company,i.org_name, p.apply_date from bgp_project_human_profess p left join comm_org_information i on p.apply_company=i.org_id and i.bsflag='0' left join comm_human_employee e on p.applicant_id=e.employee_id and e.bsflag='0' where  p.bsflag='0' ";
		cruConfig.currentPageUrl = "/rm/em/professPrepare/professPrefareList.jsp";
		queryData(1);

		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function simpleSearch(){ 
		
		var str = "";
		
		var s_project_info_no = document.getElementById("s_project_info_no").value; 
		var s_proc_status = document.getElementById("s_proc_status").value;
		
		if(s_project_info_no != ''){
			str+="project_name="+s_project_info_no;
		}
		if(s_proc_status != ''){
			str+="&prepare_status="+s_proc_status;
		} 
		 
		cruConfig.submitStr = str;
		queryData(1);
	}

	function clearQueryText(){ 
		 document.getElementById("s_project_info_no").value=""; 
		 document.getElementById("s_project_name").value=""; 
		 document.getElementById("s_proc_status").value="";
		 cruConfig.cdtStr = "";	
	}
	
    function loadDataDetail(ids){
        	var prepareNo =ids.split(",")[1];
        	var id =ids.split(",")[0];
            var project_type=ids.split(",")[4];
            
            var businessType_s="5110000004100000006";
        	if(project_type =='5000100004000000008'){
        		businessType_s="5110000004100001052";
        	}
    	 processNecessaryInfo={         
 	    		businessTableName:"bgp_human_prepare",    //置入流程管控的业务表的主表表明
 	    		businessType:businessType_s,        //业务类型 即为之前设置的业务大类
 	    		businessId:prepareNo,         //业务主表主键值
 	    		businessInfo:"多项目专业化人员调配流程",        //用于待审批界面展示业务信息
 	    		applicantDate:'<%=appDate%>'       //流程发起时间
 	    	}; 
 	    	processAppendInfo={ 
 	    			update: 'true',
 	    			id: id,
 	    			prepareNo: prepareNo,
 	    			buttonView:"false",
 	    			projectName:'<%=user.getProjectName()%>' ,
 	    			project_type:project_type,
 	    		    projectInfoNo:'<%=user.getProjectInfoNo()%>' 
 	    	};   
 	    	
 	 	document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+prepareNo;
 		    
 		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+prepareNo;
 		    
		//var querySql = "select rownum ,p.* from ( select distinct p.apply_team,d1.coding_name apply_team_name,p.post,d2.coding_name post_name, p.people_number,p.plan_start_date,p.plan_end_date,(p.plan_end_date-p.plan_start_date) nums,decode(p.age,'','','0','20-30岁','1','30-40岁','2','40岁以上') age, decode(p.work_years,'','','0','3年以下','1','3-5年','2','5-10年','3','10年以上') work_years, decode(p.culture,'','','0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他') culture  from bgp_human_prepare_post_detail p left join bgp_human_prepare h on p.prepare_no=h.prepare_no and h.bsflag='0' left join comm_coding_sort_detail d1 on p.apply_team=d1.coding_code_id and d1.bsflag='0' left join comm_coding_sort_detail d2 on p.post=d2.coding_code_id and d2.bsflag='0' where h.prepare_no='"+prepareNo+"' and p.bsflag='0' order by p.apply_team, p.post ) p ";
 		var querySql = " select  p.* ,count(swt.human_detail_no) tp_num from ( select distinct w.*  from ( select   d.post,   d.notes ,  decode(p.age,'','','0','20-30岁','1','30-40岁','2','40岁以上') age, decode(p.work_years,'','','0','3年以下','1','3-5年','2','5-10年','3','10年以上') work_years, decode(p.culture,'','','0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他') culture , d.apply_team,  d.plan_start_date,  d.plan_end_date,   (d.plan_end_date - d.plan_start_date + 1) plan_days,    d.work_trade_years,    d1.coding_name postname,  d2.coding_name apply_teamname   from bgp_project_human_profess_deta d  inner join bgp_project_human_profess_post p  on d.post_no = p.post_no  and p.bsflag = '0'  inner join bgp_project_human_profess f  on p.profess_no = f.profess_no  and f.bsflag = '0'  left join (select count(t.employee_id) al_num,  t.work_post post,  p.prepare_org_id  from bgp_human_prepare_human_detail t  inner join bgp_human_prepare p  on t.prepare_no = p.prepare_no  and p.bsflag = '0'  where p.profess_no = '"+id+"'  and t.bsflag = '0'  group by p.prepare_org_id, t.work_post) al  on al.post = d.post  and al.prepare_org_id = d.deploy_org  left join comm_org_information t1  on d.deploy_org = t1.org_id  and t1.bsflag = '0'  left join comm_org_subjection t2  on d.deploy_org = t2.org_id  and t2.bsflag = '0'  left join comm_coding_sort_detail d1  on d.post = d1.coding_code_id  left join comm_coding_sort_detail d2  on d.apply_team = d2.coding_code_id  left join comm_coding_sort_detail d3  on d.culture = d3.coding_code_id  left join (select d.post_detail_no, count(a.employee_id) num1  from bgp_comm_human_allocate_task_a a  left join bgp_project_human_profess_deta d  on d.post_detail_no = a.post_detail_no  where a.employee_id = '<%=userId%>'  group by d.post_detail_no) d4  on d4.post_detail_no = d.post_detail_no   where d.bsflag = '0'  and d.deploy_flag in ('1', '2')  and f.profess_no = '"+id+"'" +
 				"  union all   select p.post,    p.notes,   decode(p.age,'','','0','20-30岁','1','30-40岁','2','40岁以上') age, decode(p.work_years,'','','0','3年以下','1','3-5年','2','5-10年','3','10年以上') work_years, decode(p.culture,'','','0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他') culture   ,p.apply_team,  p.plan_start_date,  p.plan_end_date,  (p.plan_end_date - p.plan_start_date + 1) plan_days,  p.work_trade_years,  d1.coding_name     postname,  d2.coding_name     apply_teamname   from bgp_project_human_profess_post p  inner join bgp_project_human_profess r  on p.profess_no = r.profess_no  left join comm_coding_sort_detail d1  on p.post = d1.coding_code_id  left join comm_coding_sort_detail d2  on p.apply_team = d2.coding_code_id  left join comm_coding_sort_detail d3  on p.culture = d3.coding_code_id  left join (select count(distinct(t.employee_id)) pre_num,  t.work_post post,  p.prepare_org_id  from bgp_human_prepare_human_detail t  inner join bgp_human_prepare p  on t.prepare_no = p.prepare_no  and p.bsflag = '0'  where p.profess_no = '"+id+"'  and p.prepare_status = '2'  and t.bsflag = '0'  group by p.prepare_org_id, t.work_post) al  on al.post = p.post  and al.prepare_org_id = r.apply_company   where p.bsflag = '0'  and p.profess_no = '"+id+"'  )w)p " +
 						"  left join  (select distinct t.human_detail_no,  t.team,  t.work_post,  t.employee_id,  e.employee_name,  t.plan_start_date,  t.plan_end_date,  (t.plan_end_date - t.plan_start_date + 1) plan_days,  (t.actual_end_date -  t.actual_start_date + 1) actual_days,  t.actual_start_date,  d1.coding_name work_post_name,  d2.coding_name team_name,  t.actual_end_date,  t.spare1,  t.notes  from bgp_human_prepare_human_detail t  inner join bgp_human_prepare r  on t.prepare_no = r.prepare_no  and r.bsflag = '0'  left join comm_coding_sort_detail d1  on t.work_post = d1.coding_code_id  left join comm_coding_sort_detail d2  on t.team = d2.coding_code_id  left join comm_human_employee e  on t.employee_id = e.employee_id  and e.bsflag = '0'  where r.prepare_no =  '"+prepareNo+"'  and t.bsflag = '0'   union all  select distinct t.labor_deploy_id as human_detail_no,  d2.apply_team as team,  d2.post as work_post,  t.labor_id as employee_id,  l.employee_name,  t.start_date as plan_start_date,  t.spare4 as plan_end_date,  (t.spare4 - t.start_date + 1) plan_days,  (t.end_date - t.actual_start_date + 1) actual_days,  t.actual_start_date,  d4.coding_name work_post_name,  d3.coding_name team_name,   t.end_date as actual_end_date,  t.spare1,  t.notes  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2  on t.labor_deploy_id = d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l  on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id  left join comm_coding_sort_detail d4  on d2.post = d4.coding_code_id  where t.bsflag = '0'  and t.spare1 = '"+prepareNo+"'   )swt on swt.team=p.apply_team  and     swt.work_post=p.post  and swt.plan_start_date= p.plan_start_date   and  swt.plan_end_date  =   p.plan_end_date   group by    p.post,   p.notes,  p.age ,p.work_years,p.culture  ,p.apply_team,  p.plan_start_date,  p.plan_end_date,  p. plan_days,         p.work_trade_years,  p.postname,  p.apply_teamname   order by p.apply_team, p.post  ";
 		
 		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		
		var querySql1 = "select rownum ,p.* from (select distinct t.human_detail_no,t.team, t.work_post, t.employee_id, e.employee_name, t.plan_start_date, t.plan_end_date,(t.plan_end_date- t.plan_start_date + 1) plan_days,(t.actual_end_date- t.actual_start_date + 1) actual_days, t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name, t.actual_end_date,t.spare1,t.notes from bgp_human_prepare_human_detail t  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id  left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0' where r.prepare_no='"+prepareNo+"' and t.bsflag='0'  union all select distinct     t.labor_deploy_id as human_detail_no , d2.apply_team as team, d2.post as work_post ,  t.labor_id as employee_id,   l.employee_name,   t.start_date as plan_start_date ,  t.spare4 as  plan_end_date,  (t.spare4 - t.start_date + 1) plan_days,    (t.end_date -  t.actual_start_date + 1) actual_days,    t.actual_start_date,  d4.coding_name work_post_name, d3.coding_name team_name,     t.end_date as actual_end_date,   t.spare1,  t.notes        from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2     on t.labor_deploy_id = d2.labor_deploy_id    and d2.bsflag = '0'   left join bgp_comm_human_labor l     on t.labor_id = l.labor_id    left join comm_coding_sort_detail d3     on d2.apply_team = d3.coding_code_id   left join comm_coding_sort_detail d4     on d2.post = d4.coding_code_id    where t.bsflag = '0'  and   t.spare1= '"+prepareNo+"'  ) p ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		
		deleteTableTr("postDetailList");
		deleteTableTr("humanDetailList");
		
		loadProcessHistoryInfo();
		
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
				var tr = document.getElementById("postDetailList").insertRow();		
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}

				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].apply_teamname;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].postname;
				
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].tp_num;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].plan_start_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].plan_end_date;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas[i].plan_days;

				var td = tr.insertCell(7);
				td.innerHTML = datas[i].age;
				
				var td = tr.insertCell(8);
				td.innerHTML = datas[i].work_years;
				
				var td = tr.insertCell(9);
				td.innerHTML = datas[i].culture;
			}
		}	
				
		if(datas1 != null){
			for (var m = 0; m< queryRet1.datas.length; m++) {
				
				var tr = document.getElementById("humanDetailList").insertRow();		
				
              	if(m % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				
				var td = tr.insertCell(0);
				td.innerHTML = datas1[m].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas1[m].team_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas1[m].work_post_name;

				var td = tr.insertCell(3);
				td.innerHTML = datas1[m].employee_name;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas1[m].plan_start_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas1[m].plan_end_date;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas1[m].plan_days;
				
				var td = tr.insertCell(7);
				td.innerHTML = datas1[m].actual_start_date;

				var td = tr.insertCell(8);
				td.innerHTML = datas1[m].actual_end_date;
				
				var td = tr.insertCell(9);
				td.innerHTML = datas1[m].actual_days;

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
	
</script>
</html>