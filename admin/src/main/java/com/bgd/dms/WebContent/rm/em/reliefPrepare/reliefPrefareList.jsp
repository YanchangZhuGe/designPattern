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
	String orgSubjectionId = user.getSubOrgIDofAffordOrg();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
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
			    <td class="ali_cdn_input"><input class="input_width" id="s_project_info_no" name="s_project_info_no" type="text"  /></td>
			 
			    
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
  				<auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
  				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
  				<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton> 
  				<auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>				
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{human_relief_no},{prepare_no},{prepare_status},{project_type}' id='rdo_entity_id_{human_relief_no}'  />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{project_name}">项目名称</td>
			      <td class="bt_info_odd" exp="{prepare_status_name}">调配状态</td>
			      <td class="bt_info_even" exp="{apply_no}">申请单号</td>
			      <td class="bt_info_odd" exp="{applicant_name}">申请人</td>
			      <td class="bt_info_even" exp="{applicant_org_name}">申请单位</td>
			      <td class="bt_info_odd" exp="{prepare_id}">调配单号</td>
			      <td class="bt_info_even" exp="{deploy_org_name}">调配单位</td>
			      <td class="bt_info_odd" exp="{deploy_date}">调配时间</td>
			      <td class="bt_info_even" exp="{flow_name}">单据状态</td>	
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
//	cruConfig.queryService = "HumanCommInfoSrv";
//	cruConfig.queryOp = "searchProfessPrepare";
	
	function toAdd(){
		
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
	    var tempa = ids.split(',');		    
	    var prepare_status = tempa[2];
	    var project_type= tempa[3]; 
	    
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
	    
		popWindow('<%=contextPath%>/rm/em/toReliefPrepareEdit.srq?id='+ids.split(",")[0]+'&project_type='+project_type,'1000:800');
		
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
	    var project_type= tempa[3]; 
	    
	    if(prepare_status == 2 ){
	        alert("该调配单已提交不能修改!");
	    	return;
	    }
		if(prepare_status == 0 ){
	        alert("该调配单未调配,请先调配!");
	    	return;
	    }

		popWindow('<%=contextPath%>/rm/em/toReliefPrepareEdit.srq?update=true&id='+ids.split(",")[0]+'&prepareNo='+ids.split(",")[1]+'&project_type='+project_type,'1000:800');
		
	}
	
	function refreshData(arrObj){

		var str = "select decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) flow_name,r.apply_no, decode(r.proc_status, '3', '审核通过') proc_status, pr.spare2 audit_status, r.human_relief_no,  p.project_type,  p.project_name, t2.employee_name applicant_name, r1.deploy_org org_id, i.org_abbreviation applicant_org_name, i1.org_abbreviation deploy_org_name, To_char(r.apply_date, 'yyyy-MM-dd') apply_date,pr.prepare_no, pr.prepare_id, pr.applicant_id,t1.employee_name, To_char(pr.deploy_date, 'yyyy-MM-dd') deploy_date, nvl(pr.prepare_status, '0') prepare_status, decode(pr.prepare_status, '0', '待调配','1', '调配中', '2', '已调配', '待调配') prepare_status_name  from (select pro.apply_no, de.deploy_org from bgp_project_human_relief_deta de left join bgp_project_human_reliefdetail po on po.post_no =  de.post_no left join bgp_project_human_relief pro on po.human_relief_no =  pro.human_relief_no where pro.bsflag = '0'  and po.bsflag = '0' and de.bsflag = '0' group by pro.apply_no, de.deploy_org order by pro.apply_no) r1 left join bgp_project_human_relief r on r.apply_no = r1.apply_no and r.bsflag = '0' left join gp_task_project p on r.project_info_no = p.project_info_no and p.bsflag = '0' left join bgp_human_prepare pr on r.human_relief_no = pr.human_relief_no and pr.prepare_org_id = r1.deploy_org and pr.bsflag = '0' and r.bsflag = '0' left join common_busi_wf_middle te on    te.business_id=pr.prepare_no   and te.business_type in ('5110000004100000044','5110000004100001051')  and te.bsflag='0' left join common_busi_wf_middle te1 on  te1.business_id=r.human_relief_no  and te1.business_type in ('5110000004100000026','5110000004100001053') and te1.bsflag='0' left join comm_org_information i on r.apply_company = i.org_id and i.bsflag = '0'  left join comm_org_information i1 on pr.prepare_org_id = i1.org_id and i1.bsflag = '0' left join comm_human_employee t1 on pr.applicant_id = t1.employee_id and t1.bsflag = '0' left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0'  left join comm_org_subjection s on r1.deploy_org=s.org_id and s.bsflag='0' where r.bsflag = '0'  and s.org_subjection_id like '<%=orgSubjectionId%>%' ";
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
				if(arrObj[key].label =='prepare_status'){
					str += "  and pr."+arrObj[key].label+" ='"+arrObj[key].value+"' ";
				}else  if(arrObj[key].label =='project_name'){
					str += "  and p."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}else {									
					str += "  and r."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}	  
			}			
		cruConfig.queryStr=str;			
		cruConfig.currentPageUrl = "/rm/em/reliefPrepare/reliefPrefareList.jsp";
		queryData(1);

		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		 
		popWindow('<%=contextPath%>/rm/em/reliefPrepare/doc_search.jsp');
	}
	function simpleSearch(){ 
		
		var str = " 1=1 ";
		
		var s_project_info_no = document.getElementById("s_project_info_no").value; 

		if(s_project_info_no !=''){
			str = str + "and project_name like '"+s_project_info_no+"%' ";			
		}
		cruConfig.cdtStr = str;		
		refreshData();
	}
	function clearQueryText(){ 
		 document.getElementById("s_project_info_no").value=''; 
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
	    
	    if(prepare_status == 2){
	    	alert("该调配已提交,不允许再次提交");
	    	return;
	    }
		if(prepare_status == 0 ){
	        alert("该调配单未调配,请先调配!");
	    	return;
	    }

		if (!window.confirm("确认要提交吗?")) {
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
		
		submitProcessInfo();
		refreshData();
	}

    function loadDataDetail(ids){


    	var human_relief_no=ids.split(",")[0];
    	var prepare_no=ids.split(",")[1];
    	var project_type= ids.split(",")[3];
    	
    	var businessType_s="5110000004100000044";
    	if(project_type =='5000100004000000008'){
    		businessType_s="5110000004100001051";
    	}
    	  processNecessaryInfo={         
	    		businessTableName:"bgp_human_prepare",    //置入流程管控的业务表的主表表明
	    		businessType:businessType_s,        //业务类型 即为之前设置的业务大类
	    		businessId: prepare_no,         //业务主表主键值
	    		businessInfo:"多项目人员调剂调配",        //用于待审批界面展示业务信息
	    		applicantDate:'<%=appDate%>'       //流程发起时间
	    	}; 
	    	processAppendInfo={ 	    		 
	    				id: human_relief_no,
	    				prepareNo:prepare_no,
	    				update: 'true',
	    				project_type:project_type,
	    				projectName:'<%=user.getProjectName()%>'
	    				
	     	};   
	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+prepare_no;		    
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+prepare_no;
	    	
		var querySql = "select rownum ,p.* from ( select p.apply_team,d1.coding_name apply_team_name,p.post,d2.coding_name post_name, p.people_number,p.plan_start_date,p.plan_end_date,(p.plan_end_date-p.plan_start_date) nums,decode(p.age,'','','0','20-30岁','1','30-40岁','2','40岁以上') age, decode(p.work_years,'','','0','3年以下','1','3-5年','2','5-10年','3','10年以上') work_years, decode(p.culture,'','','0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他') culture  from bgp_human_prepare_post_detail p left join bgp_human_prepare h on p.prepare_no=h.prepare_no and h.bsflag='0' left join comm_coding_sort_detail d1 on p.apply_team=d1.coding_code_id and d1.bsflag='0' left join comm_coding_sort_detail d2 on p.post=d2.coding_code_id and d2.bsflag='0' where h.prepare_no='"+ids.split(",")[1]+"' and p.bsflag='0' order by p.apply_team, p.post ) p ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;	
		
		var querySql1 = "select rownum ,p.* from (select t.human_detail_no,t.team, t.work_post, t.employee_id, e.employee_name, t.plan_start_date, t.plan_end_date,(t.plan_end_date- t.plan_start_date + 1) plan_days,(t.actual_end_date- t.actual_start_date + 1) actual_days, t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name, t.actual_end_date,t.spare1,t.notes from bgp_human_prepare_human_detail t  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id  left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0' where r.prepare_no='"+ids.split(",")[1]+"' and t.bsflag='0' ) p ";
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
				td.innerHTML = datas[i].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].apply_team_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].post_name;
				
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].people_number;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].plan_start_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].plan_end_date;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas[i].nums;

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