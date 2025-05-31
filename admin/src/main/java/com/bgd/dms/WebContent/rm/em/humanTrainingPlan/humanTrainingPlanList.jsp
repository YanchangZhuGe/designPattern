<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo =  user.getProjectInfoNo();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String subOrgId = (user==null)?"":user.getSubOrgIDofAffordOrg();
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
  <title>多项目人员培训计划</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  <td  width="5%">	 项目名称   </td>
			    <td  width="25%">		    
			    <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
		    	<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"  />   
			    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   
			     </td>
		 
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
				
			    <td width="55%">&nbsp;</td>
			 
			    <td>   </td>
			   
  				
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
			      <td class="bt_info_odd" 	 exp="<input type='checkbox' name='chx_entity_id'  id='chx_entity_id{train_plan_no}' value='{train_plan_no},{proc_status},{org_id},{plan_number},{project_name},{project_type}'\>"> </td>
					<td class="bt_info_even" 	 autoOrder="1">序号</td>
					<td class="bt_info_odd" 	 exp="{plan_number}" >单号</td>
					<td class="bt_info_even" 	 exp="{project_name}">项目名称</td>
					<td class="bt_info_odd" 	 exp="{train_amount}">费用（元）</td>
					<td class="bt_info_even" 	 exp="{proc_status_name}">单据状态</td>
					<td class="bt_info_odd" 	 exp="{applicant_name}">提交人</td>
					<td class="bt_info_even" 	 exp="{applicant_org_name}">所属单位</td>
					<td class="bt_info_odd" 	 exp="{create_date}">提交时间</td>
					
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
				    <li  id="tag3_1" ><a href="#" onclick="getTab3(1)">单据明细</a></li>
				    <li id="tag3_2"><a href="#" onclick="getTab3(2)">附件</a></li>			 
				    <li id="tag3_3"><a href="#" onclick="getTab3(3)">备注</a></li>
				    <li id="tag3_4"><a href="#" onclick="getTab3(4)">审批流程</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" class="tab_box_content" >
			<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
		    <tr>
		      <td   class="inquire_item6">单号：</td>
		      <td   class="inquire_form6" >
		      <input type="text"   value="" id="planNumber"  name="planNumber" class='input_width' readonly="readonly"></input>
		      </td>
		      <td  class="inquire_item6">&nbsp;培训对象：</td>
		      <td  class="inquire_form6"  >
		      <input type="text"   value="" id="trainObject" name="trainObject" class='input_width'></input>
		      </td>		    
		      </tr>
		     <tr >
		     <td  class="inquire_item6">培训地点：</td>
		     <td  class="inquire_form6">
		     <input type="text" value="" id="trainAddress" name="trainAddress" class='input_width'  ></input>
		     </td> 
		     <td  class="inquire_item6">&nbsp;项目名称：</td>
		     <td  class="inquire_form6">
		     <input type="text"  readonly="readonly" value="" id="projectName" name="projectName" class='input_width'></input> 
		     </td>      		    
		     </tr>
		     
		     <tr >
		     <td  class="inquire_item6">施工队伍：</td>
		     <td  class="inquire_form6">
		     <input type="text" value="" id="applicantOrgName" name="applicantOrgName" class='input_width' readonly="readonly"></input>
		     </td> 
		     <td  class="inquire_item6">&nbsp;提交人：</td>
		     <td  class="inquire_form6">
		     <input type="text" value="" id="applicantName" name="applicantName" class='input_width' readonly="readonly"></input> 
		     </td>      		    
		     </tr>
		     
		     <tr >
		     <td  class="inquire_item6">培训时间：</td>
		     <td  class="inquire_form6">
		     <input type="text"     value="" id="trainCycle" name="trainCycle" class='input_width'  ></input>
		     </td> 
		     <td  class="inquire_item6">&nbsp;培训目的：</td>
		     <td  class="inquire_form6">
		     <input type="text"   value="" id="trainPurpose" name="trainPurpose" class='input_width'  ></input> 
		     </td>      		    
		     </tr>
		     
		     </table>
			</div>
			
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table id="professDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top:2px;" >
				    	<tr  >
				    	  <td  class="bt_info_odd">序号</td>
				            <td  class="bt_info_even">培训内容</td>
				            <td  class="bt_info_odd">分类</td>
				            <td class="bt_info_even">人数</td>
				            <td class="bt_info_odd">学时</td>
				            <td class="bt_info_even">授课费</td>
				            <td class="bt_info_odd">交通费</td>
				            <td class="bt_info_even">材料费</td>
				            <td class="bt_info_odd">场地费</td>
				            <td class="bt_info_even">食宿费</td>
				            <td class="bt_info_odd">其他费用</td>			
				            <td class="bt_info_even">合计（元）</td>  
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
	
 
	function toAdd(){
		 
		popWindow('<%=contextPath%>/rm/em/toHumanPlanEdit.srq?projectInfoNo=<%=projectInfoNo%>&func=1','1024:800');
	
	}
	
	function toEdit(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	    var tempa = ids.split(',');		
	    var train_plan_no =  tempa[0];    
	    var proc_status = tempa[1];		    
	   
	    if(proc_status == 2 ){
	        alert("该信息单已提交不能修改!");
	    	return;
	    }
		 
	 
			popWindow("<%=contextPath%>/rm/em/toHumanPlanEdit.srq?id="+train_plan_no+"&update=true&func=1","1024:800");
			//editUrl = "/rm/em/toHumanPrepareEdit.srq?id="+requirement_no+"&update=true"+"&prepareNo="+prepare_no+"&func=1";
	    	//window.location=cruConfig.contextPath+editUrl+"&backUrl="+cruConfig.currentPageUrl;
	
	}
	
	function toDelete(){
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 

	    var tempa = ids.split(',');
	    
	    var train_plan_no =  tempa[0];    
	    var proc_status = tempa[1];		    		  
	    

	    if(proc_status == 2){
	    	alert("该信息已通过,不允许删除");
	    	return;
	    }
			 	 
		var sql = "update BGP_COMM_HUMAN_TRAINING_PLAN set bsflag='1' where train_plan_no ='"+train_plan_no+"'";
		deleteEntities(sql);
		alert('删除成功！');
	}
	
	function toSubmit(){
		
		ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 

	    var tempa = ids.split(',');
	    
	    var train_plan_no =  tempa[0];    
	    var proc_status = tempa[1];		    		  
	        		 
	    if(proc_status == 3){
	    	alert("该信息已审核通过,不允许再次提交");
	    	return;
	    }
			  
		var sql = "update BGP_COMM_HUMAN_TRAINING_PLAN set modifi_date=sysdate ,proc_status='2'  where train_plan_no ='"+train_plan_no+"'";
		updateEntitiesBySql(sql,"提交");
		refreshData();
		alert('提交成功！');
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
	 
	
	// 简单查询
	function simpleSearch(){
		
		var s_project_info_no = document.getElementById("s_project_name").value;

		var str = " 1=1 ";
		
		if(s_project_info_no!=''){			
			str += "  and  project_name like '%"+s_project_info_no+"%' ";						
		}	
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	function clearQueryText(){
		document.getElementById("s_project_info_no").value="";
		document.getElementById("s_project_name").value="";
		
	}
	
	function refreshData(){

		cruConfig.queryStr = "select * from (select   p.project_type,  pn.train_plan_no, pn.plan_number,pn.project_info_no,nvl(pn.train_amount,'0') train_amount,nvl(te.proc_status, '0') proc_status, p.project_name,  i.org_id,     nvl( pn.org_name ,i.org_abbreviation) applicant_org_name,    " +
			"   decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name,pn.creator,       To_char(pn.create_date, 'yyyy-MM-dd hh24:mi') create_date,pn.spare1 ,  t2.employee_name applicant_name  from BGP_COMM_HUMAN_TRAINING_PLAN  pn       left join common_busi_wf_middle te on    te.business_id=pn.train_plan_no   and te.bsflag='0'      left join gp_task_project p    on pn.project_info_no = p.project_info_no   and p.bsflag = '0'    left join comm_org_information i    on pn.spare1 = i.org_id   and i.bsflag = '0'       left join comm_human_employee t2    on pn.creator = t2.employee_id   and t2.bsflag = '0'  where pn.bsflag='0'  and te.proc_status in('1','3','4')  and pn.spare3 like '<%=subOrgId%>%' union all select    p.project_type, pn.train_plan_no, pn.plan_number,pn.project_info_no,nvl(pn.train_amount,'0') train_amount,nvl(pn.spare2, '0') proc_status, p.project_name,  i.org_id,       nvl( pn.org_name ,i.org_abbreviation) applicant_org_name,     decode(pn.spare2,  '1',   '已提交','未提交') proc_status_name,pn.creator,       To_char(pn.modifi_date, 'yyyy-MM-dd hh24:mi') create_date,pn.spare1 ,  t2.employee_name applicant_name  from BGP_COMM_HUMAN_TRAINING_PLAN  pn           left join gp_task_project p    on pn.project_info_no = p.project_info_no   and p.bsflag = '0'    left join comm_org_information i    on pn.spare1 = i.org_id   and i.bsflag = '0'       left join comm_human_employee t2    on pn.creator = t2.employee_id   and t2.bsflag = '0'  where pn.bsflag='0'  and  pn.spare2='1' and pn.spare3 like '<%=subOrgId%>%'  )  ";
		cruConfig.currentPageUrl = "/rm/em/singleHuman/humanTrainingPlan/humanTrainingPlanList.jsp";
		queryData(1);

		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");

	function toSearch(){
		
	}


    function loadDataDetail(ids){
    	 var tempa = ids.split(',');
 	    
 	    var trainPlanId =  tempa[0];    
	    var prepare_no =  tempa[2];	    
	    var plan_number = tempa[3];
	    var project_name = tempa[4];	    
	  	var project_type= tempa[5];
	  	
		var businessType_s="5110000004100000008";
    	if(project_type =='5000100004000000008'){
    		businessType_s="5110000004100001056";
    	}
	  	
	    processNecessaryInfo={         
	    		businessTableName:"BGP_COMM_HUMAN_TRAINING_PLAN",    //置入流程管控的业务表的主表表明
	    		businessType:businessType_s,        //业务类型 即为之前设置的业务大类
	    		businessId:trainPlanId,         //业务主表主键值
	    		businessInfo:" 人员培训计划流程",        //用于待审批界面展示业务信息
	    		applicantDate:'<%=appDate%>'       //流程发起时间
	    	}; 
	    	processAppendInfo={ 
	    			id: trainPlanId	 
	    	};   
	    	
	    document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+trainPlanId;
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+trainPlanId;
 		var querySql = " select dl.train_detail_no,  dl.train_content,decode(dl.classification,   '1',   '质量',  '2',  'HSE',  '4',  'HSE和质量', '5',  '操作技能','3', '其他',dl.classification) classification,dl.train_number,dl.train_class ,nvl(dl.train_cost ,'0') train_cost,nvl(dl.train_transportation,'0')train_transportation,nvl(dl.train_materials,'0') train_materials,nvl(dl.train_places,'0') train_places,nvl(dl.train_accommodation,'0') train_accommodation,nvl(dl.train_other,'0') train_other,nvl(dl.train_total,'0') train_total  from BGP_COMM_HUMAN_TRAINING_DETAIL dl  inner join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no=pn.train_plan_no  and pn.bsflag='0'  where dl.bsflag='0' and pn.train_plan_no='"+trainPlanId+"' order by dl.create_date desc";
 		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas; 
		
		var  querySql1="select pn.train_object,pn.train_address,pn.train_purpose,pn.train_cycle,pn.train_plan_no, pn.plan_number,pn.project_info_no,nvl(pn.train_amount,'0') train_amount,nvl(pn.proc_status, '0') proc_status, p.project_name,  i.org_id,       nvl( pn.org_name ,i.org_abbreviation) applicant_org_name,      decode(pn.proc_status,     '0',    '待审核',     '1',     '审核不通过',   '2',    '审核通过',  '未提交') proc_status_name,pn.creator,       To_char(pn.create_date, 'yyyy-MM-dd hh24:mi') create_date,pn.spare1 ,  t2.employee_name applicant_name  from BGP_COMM_HUMAN_TRAINING_PLAN  pn                left join gp_task_project p    on pn.project_info_no = p.project_info_no   and p.bsflag = '0'    left join comm_org_information i    on pn.spare1 = i.org_id   and i.bsflag = '0'       left join comm_human_employee t2    on pn.creator = t2.employee_id   and t2.bsflag = '0'  where pn.bsflag='0'    and pn.train_plan_no='"+trainPlanId+"' "; 
 		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql1);
		var datas1 = queryRet1.datas;
	 
		document.getElementById("planNumber").value =datas1[0].plan_number;
		document.getElementById("trainObject").value =datas1[0].train_object;
		document.getElementById("trainAddress").value =datas1[0].train_address;
		document.getElementById("projectName").value =datas1[0].project_name;
		
		document.getElementById("applicantOrgName").value =datas1[0].applicant_org_name;
		document.getElementById("applicantName").value =datas1[0].applicant_name;
		document.getElementById("trainCycle").value =datas1[0].train_cycle;
		document.getElementById("trainPurpose").value =datas1[0].train_purpose;
		
		
		deleteTableTr("professDetailList");		 
		loadProcessHistoryInfo();
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
				var tr = document.getElementById("professDetailList").insertRow();		
				
              	if(i % 2 == 1){  
              		tr.className = "even";
				}else{ 
					tr.className = "odd";
				}

              	
				var td = tr.insertCell(0);
				td.innerHTML = i+1;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas[i].train_content;
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].classification;
				
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].train_number;

				var td = tr.insertCell(4);
				td.innerHTML = datas[i].train_class;

				var td = tr.insertCell(5);
				td.innerHTML = datas[i].train_cost;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas[i].train_transportation;
				
				var td = tr.insertCell(7);
				td.innerHTML = datas[i].train_materials;
				
				var td = tr.insertCell(8);
				td.innerHTML = datas[i].train_places;
				
				var td = tr.insertCell(9);
				td.innerHTML = datas[i].train_accommodation;
				
				var td = tr.insertCell(10);
				td.innerHTML = datas[i].train_other;
				
				var td = tr.insertCell(11);
				td.innerHTML = datas[i].train_total;
 


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