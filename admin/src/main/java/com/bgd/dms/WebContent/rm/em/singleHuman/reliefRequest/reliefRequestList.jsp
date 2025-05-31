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
	String projectInfoNo = user.getProjectInfoNo();
	
	String businessType_s="5110000004100000026";
	String projectType = user.getProjectType();	
	if(projectType.equals("5000100004000000008")){
		projectType="5000100004000000001";
		businessType_s="5110000004100001053";
	}
	if(projectType.equals("5000100004000000010")){
		projectType="5000100004000000001";
	} 
	if(projectType.equals("5000100004000000002")){
		projectType="5000100004000000001";
	}
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
//	String projectInfoNo = "8a9588b63618fc0d01361a93e0bf0018";


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
			    <td background="<%=contextPath%>/images/list_15.png">
			    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  
			    <td>&nbsp;</td>		 
				<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>	
				<auth:ListButton functionId="F_HUMAN_007" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>			
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{human_relief_no}-{proc_status}' id='rdo_entity_id_{human_relief_no}' onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{project_name}">项目名称</td>
			      <td class="bt_info_odd" exp="{apply_no}">单号</td>
			      <td class="bt_info_even" exp="{proc_status_name}">单据状态</td>			     
			      <td class="bt_info_odd" exp="{employee_name}">提交人</td>
			      <td class="bt_info_even" exp="{org_name}">所属单位</td>
			      <td class="bt_info_odd" exp="{apply_date}">提交时间</td>
			   
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
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">审批流程</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="professDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>序号</td>
				            <td>班组</td>
				            <td>岗位</td>		
				            <td>计划人数</td>
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
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" >
					</iframe>					
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
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
	var projectInfoNo='<%=projectInfoNo%>';
	
	function toAdd(){

		popWindow('<%=contextPath%>/rm/em/toReliefRequiredEdit.srq?projectInfoNo=<%=projectInfoNo%>&projectInfoType=<%=projectType%>','900:750');
	
	}
	
	function toEdit(){

		ids = getSelectedValue();
		if(ids==''){ 
			alert("请先选中一条记录!");
		    return;
		}
		if(ids.split("-")[1] == "1" || ids.split("-")[1] == "3"){
			alert("该需求申请开始审核,不能修改");
			return;
		}
		popWindow('<%=contextPath%>/rm/em/toReliefRequiredEdit.srq?id='+ids.split("-")[0]+'&projectInfoNo=<%=projectInfoNo%>&projectInfoType=<%=projectType%>','900:750');
	
	}
	
	function toDelete(){
		
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}	
		if(ids.split("-")[1] == "1" || ids.split("-")[1] == "3"){
			alert("该需求申请开始审核,不能删除");
			return;
		}
		if (!window.confirm("确认要删除吗?")) {
			return;
		}

		var sql = "update bgp_project_human_relief t set t.bsflag='1',modifi_date=sysdate where t.human_relief_no ='"+ids.split("-")[0]+"'";

		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		var retObject = syncRequest('Post',path,params);
		refreshData();
		deleteTableTr("professDetailList");

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

    
    
	function toSubmit(){
		
		ids = getSelectedValue();
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}		
		if (!window.confirm("确认要提交吗?")) {
			return;
		}
		submitProcessInfo();
		refreshData();
	}
	

	function refreshData(){
		
		if(projectInfoNo != ''){
			cruConfig.queryStr = "select te.proc_status, decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name, p.human_relief_no,p.project_info_no,p1.project_name, p.apply_no,p.apply_state,p.applicant_id,e.employee_name, p.apply_company,i.org_name, p.apply_date from bgp_project_human_relief p   left join common_busi_wf_middle te on    te.business_id=p.human_relief_no   and te.bsflag='0' and te.business_type in ('5110000004100000026','5110000004100001053')  left join gp_task_project p1 on p.project_info_no=p1.project_info_no and p1.bsflag='0' left join comm_org_information i on p.apply_company=i.org_id and i.bsflag='0' left join comm_human_employee e on p.applicant_id=e.employee_id and e.bsflag='0' where p.project_info_no='"+projectInfoNo+"' and p.bsflag='0'  order by  te.proc_status asc,  p.apply_date desc ";
			cruConfig.currentPageUrl = "/rm/em/singleHuman/reliefRequest/reliefRequestList.jsp";
			queryData(1);
		}
		
	}

	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");


    function loadDataDetail(ids){
    	  processNecessaryInfo={         
  	    		businessTableName:"bgp_project_human_relief",    //置入流程管控的业务表的主表表明
  	    		businessType:"<%=businessType_s%>",        //业务类型 即为之前设置的业务大类
  	    		businessId:ids.split("-")[0],         //业务主表主键值
  	    		businessInfo:"单项目人员调剂申请",        //用于待审批界面展示业务信息
  	    		applicantDate:'<%=appDate%>'       //流程发起时间
  	    	}; 
  	    	processAppendInfo={ 
  	    			 id: ids.split("-")[0],
  	    			 projectInfoNo:'<%=projectInfoNo%>',
  	    			 buttonView:"false",
  	    			 projectInfoType:'<%=projectType%>',
  	    		     projectName:'<%=user.getProjectName()%>' 
  	    	};   
  	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];  	    
    	document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0];    	
		var querySql = "select rownum ,p.* from ( select p.apply_team,d1.coding_name apply_team_name,p.post,d2.coding_name post_name, p.people_number,p.plan_start_date,p.plan_end_date,(p.plan_end_date-p.plan_start_date) nums,decode(p.age,'','','0','20-30岁','1','30-40岁','2','40岁以上') age, decode(p.work_years,'','','0','3年以下','1','3-5年','2','5-10年','3','10年以上') work_years, decode(p.culture,'','','0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他') culture  from bgp_project_human_reliefdetail p left join comm_coding_sort_detail d1 on p.apply_team=d1.coding_code_id and d1.bsflag='0' and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on p.post=d2.coding_code_id and d2.bsflag='0' and d2.coding_mnemonic_id='<%=projectType%>'  where p.human_relief_no='"+ids.split("-")[0]+"' and p.bsflag='0' order by p.apply_team, p.post ) p ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;		
		deleteTableTr("professDetailList");
		
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