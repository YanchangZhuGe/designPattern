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
	  String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();	
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
			  <td   class="ali_cdn_name"  >	 项目名称   </td>
			    <td  width="20%">		    
			    <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
		    	<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"   />   
			    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   
			     </td>
			     <td class="ali_cdn_name">单据状态</td>
				    <td  width="20%">
				    <select name="s_proc_status" id="s_proc_status" class="select_width" >
				    <option value="">请选择</option>
				    <option value="1">待审核</option>
				    <option value="3">审批通过</option>
				    <option value="4">审批不通过</option>
				    </select>			     
				    </td>
				    
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				
			    <td width="35%">&nbsp;</td>
  				<auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{profess_no}-{project_type}' id='rdo_entity_id_{profess_no}' />" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{project_name}">项目名称</td>
			      <td class="bt_info_odd" exp="{apply_no}">单号</td>
			      <td class="bt_info_even" exp="{proc_status_name}">单据状态</td>
			      <td class="bt_info_odd" exp="{employee_name}">申请人</td>
			      <td class="bt_info_even" exp="{org_name}">申请单位</td>
			      <td class="bt_info_odd" exp="{apply_date}">申请时间</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">单据</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">审核调配</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getTab3(4)">审批流程</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="professDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>班组</td>
				            <td>岗位</td>		
				            <td>自有人数</td>
				            <td>需调配人数</td>
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
					<table id="postDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>班组</td>
				            <td>岗位</td>		
				            <td>调配单位</td>
				            <td>调配人数</td>	
				            <td>预计进入项目时间</td> 
				            <td>预计离开项目时间</td> 
				            <td>预计在项目天数</td>		
				            <td>年龄</td>			
				            <td>工作年限</td> 
				            <td>文化程度</td> 
				            <td>备注</td> 
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
	var org_subjection_idA="<%=orgSubjectionId%>";
	
	function toSubmit(){
		ids = getSelectedValue();

		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
		popWindow('<%=contextPath%>/rm/em/toProfessionAuditEdit.srq?id='+ids,'1000:800');
		
	}
	
	function refreshData(arrObj){

		var str = "select t.project_type,  te.proc_status, decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name, p.profess_no,p.project_info_no,t.project_name, p.apply_no,p.apply_state,p.applicant_id,e.employee_name, p.apply_company,i.org_name, p.apply_date from bgp_project_human_profess p   left join common_busi_wf_middle te on    te.business_id=p.profess_no   and te.bsflag='0' and business_type in ('5110000004100000023','5110000004100001054')  left join comm_org_information i on p.apply_company=i.org_id and i.bsflag='0'   left join comm_org_subjection cosb   on i.org_id=cosb.org_id  and cosb.bsflag='0'  left join gp_task_project t on p.project_info_no=t.project_info_no and t.bsflag='0' left join comm_human_employee e on p.applicant_id=e.employee_id and e.bsflag='0' where  p.bsflag='0'     and cosb.org_subjection_id like'"+org_subjection_idA+"%'     ";
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!='')
				if(arrObj[key].label =='proc_status'){
					str += "  and te."+arrObj[key].label+" ='"+arrObj[key].value+"' ";
				}else  if(arrObj[key].label =='project_name'){
					str += "  and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}else {									
					str += "  and p."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}	  
			}		
		str+="   order by   te.proc_status asc, p.apply_date desc    "
		cruConfig.queryStr=str;
		cruConfig.currentPageUrl = "/rm/em/professAudit/professAuditList.jsp";
		queryData(1);

		
	}

	function toSearch(){
 
		popWindow('<%=contextPath%>/rm/em/professAudit/doc_search.jsp');
	}
	// 简单查询
	function simpleSearch(){
		
		var s_project_info_no = document.getElementById("s_project_name").value;
		var s_proc_status = document.getElementById("s_proc_status").value;
		
		var str = " 1=1 ";
		
		if(s_project_info_no!=''){			
			str += "  and  project_name like '%"+s_project_info_no+"%' ";						
		}	
		if(s_proc_status!=''){			
			str += " and proc_status like '"+s_proc_status+"%' ";						
		}
		
		
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	function clearQueryText(){
		document.getElementById("s_project_info_no").value="";
		document.getElementById("s_project_name").value="";
		document.getElementById("s_proc_status").value="";
	}
	
	
	//选择项目
	function selectTeam(){

	    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("s_project_info_no").value = checkStr[0];
		        document.getElementById("s_project_name").value = checkStr[1];
	    }
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

 

    function loadDataDetail(ids){
     
    	var project_type=ids.split("-")[1];
    	
    	var businessType_s="5110000004100000023";
    	if(project_type =='5000100004000000008'){
    		businessType_s="5110000004100001054";
    	}
    	
    	   processNecessaryInfo={         
   	    		businessTableName:"bgp_project_human_profess",    //置入流程管控的业务表的主表表明
   	    		businessType:businessType_s,        //业务类型 即为之前设置的业务大类
   	    		businessId:ids.split("-")[0],         //业务主表主键值
   	    		businessInfo:"多项目专业化人员需求审核",        //用于待审批界面展示业务信息
   	    		applicantDate:'<%=appDate%>'       //流程发起时间
   	    	}; 
   	    	processAppendInfo={ 
   	    			id: ids.split("-")[0] ,
   	    		 	projectName:'<%=user.getProjectName()%>' 
   	    	};   
       	
   	     document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0];
 	    
 	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];
 	    
		var querySql = "select rownum ,p.* from ( select p.apply_team,d1.coding_name apply_team_name,p.post,d2.coding_name post_name, p.own_num,p.deploy_num,p.plan_start_date,p.plan_end_date,(p.plan_end_date-p.plan_start_date) nums,decode(p.age,'','','0','20-30岁','1','30-40岁','2','40岁以上') age, decode(p.work_years,'','','0','3年以下','1','3-5年','2','5-10年','3','10年以上') work_years, decode(p.culture,'','','0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他') culture  from bgp_project_human_profess_post p left join comm_coding_sort_detail d1 on p.apply_team=d1.coding_code_id and d1.bsflag='0' left join comm_coding_sort_detail d2 on p.post=d2.coding_code_id and d2.bsflag='0' where p.profess_no='"+ids.split("-")[0]+"' and p.bsflag='0' order by p.apply_team, p.post ) p ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;	
		
		var querySql1 = "select rownum, p.* from (select d.apply_team, d1.coding_name apply_team_name, d.post, d2.coding_name post_name, d.people_number,d.deploy_org,i.org_name, d.plan_start_date, d.plan_end_date,(d.plan_end_date - d.plan_start_date) nums,decode(d.age,'','','0','20-30岁','1','30-40岁','2','40岁以上') age, decode(d.work_years,'','','0','3年以下','1','3-5年','2','5-10年','3','10年以上') work_years, decode(d.culture,'','','0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他') culture,d.notes from bgp_project_human_profess_deta d inner join bgp_project_human_profess_post p on d.post_no = p.post_no and p.bsflag = '0'   inner join bgp_project_human_profess f on p.profess_no=f.profess_no and f.bsflag='0' left join comm_coding_sort_detail d1 on d.apply_team = d1.coding_code_id and d1.bsflag = '0' left join comm_coding_sort_detail d2 on d.post = d2.coding_code_id and d2.bsflag = '0' left join comm_org_information i on d.deploy_org=i.org_id and i.bsflag='0'  where f.profess_no='"+ids.split("-")[0]+"' and d.bsflag = '0'  order by d.apply_team, d.post ) p ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		
		deleteTableTr("professDetailList");
		deleteTableTr("postDetailList");
		
		loadProcessHistoryInfo();
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
				var tr = document.getElementById("professDetailList").insertRow();		
				
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
				td.innerHTML = datas[i].own_num;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].deploy_num;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].plan_start_date;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas[i].plan_end_date;
				
				var td = tr.insertCell(7);
				td.innerHTML = datas[i].nums;

				var td = tr.insertCell(8);
				td.innerHTML = datas[i].age;
				
				var td = tr.insertCell(9);
				td.innerHTML = datas[i].work_years;
				
				var td = tr.insertCell(10);
				td.innerHTML = datas[i].culture;
			}
		}	
				
		if(datas1 != null){
			for (var m = 0; m< queryRet1.datas.length; m++) {
				
				var tr = document.getElementById("postDetailList").insertRow();		
				
              	if(m % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
				
				var td = tr.insertCell(0);
				td.innerHTML = datas1[m].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas1[m].apply_team_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas1[m].post_name;

				var td = tr.insertCell(3);
				td.innerHTML = datas1[m].org_name;
				
				var td = tr.insertCell(4);
				td.innerHTML = datas1[m].people_number;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas1[m].plan_start_date;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas1[m].plan_end_date;
				
				var td = tr.insertCell(7);
				td.innerHTML = datas1[m].nums;

				var td = tr.insertCell(8);
				td.innerHTML = datas1[m].age;
				
				var td = tr.insertCell(9);
				td.innerHTML = datas1[m].work_years;
				
				var td = tr.insertCell(10);
				td.innerHTML = datas1[m].culture;
				
				var td = tr.insertCell(11);
				td.innerHTML = datas1[m].notes;
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