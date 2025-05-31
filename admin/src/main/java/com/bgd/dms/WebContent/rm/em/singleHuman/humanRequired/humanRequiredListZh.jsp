<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
  String contextPath = request.getContextPath();
  UserToken user = OMSMVCUtil.getUserToken(request);
  String orgSubjectionId = user.getOrgSubjectionId();  
 
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	
  String folderId = "";
  if(request.getParameter("folderid") != null){
    folderId = request.getParameter("folderid");
  }
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
<title>人员申请列表</title>
</head>

<body style="background:#fff"  onload="refreshData()">
        <div id="list_table" >
      <div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
          <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
 
  	    <td class="ali_cdn_name">单号</td>
 	    <td class="ali_cdn_input"><input id="s_apply_no" class="input_width"  name="s_apply_no" type="text"   /></td>
          <td class="ali_query">
		    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	       </td>
	       <td class="ali_query">
		    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
	    	</td>
          <td>&nbsp;</td>	    
          <auth:ListButton functionId="" css="zj" event="onclick='shenqingAdd()'" title="JCDP_btn_add"></auth:ListButton>
          <auth:ListButton functionId="" css="xg" event="onclick='xiugai()'" title="JCDP_btn_edit"></auth:ListButton>
          <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
          <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
          <auth:ListButton functionId="F_HUMAN_0016" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
        
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
            <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{requirement_no}-{proc_status}' id='rdo_entity_id_{requirement_no}' onclick='chooseOne(this);' />" >选择</td>
            <td class="bt_info_even" autoOrder="1">序号</td>
            <td class="bt_info_odd" exp="<input id='projectName' value='{project_name}' type='hidden'>{project_name}">项目名称</td>
            <td class="bt_info_even" exp="<a href='#' onclick=view_page('{requirement_no}')><font color='blue'>{apply_no}</font></a>" >单号</td>
            <td class="bt_info_odd" exp="{proc_status_name}">单据状态</td>   
            <td class="bt_info_even" exp="{applicant_name}">提交人</td>
            <td class="bt_info_odd" exp="{applicant_org_name}">所属单位</td>
            <td class="bt_info_even" exp="{apply_date}">提交时间</td>
          </tr>
        </table>
        
      </div>
      <div id="fenye_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
          <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">单据明细</a></li>
          <li id="tag3_1"><a href="#" onclick="getTab3(1)">附件</a></li>
          <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
 
        </ul>
      </div>
      
      <div id="tab_box" class="tab_box">
        <div id="tab_box_content0" class="tab_box_content">
         <table id="professDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
            <tr class="bt_info">
                  <td>序号</td>
                  <td>班组</td>
                  <td>岗位</td>
                  <td>本次申请人数</td>
                  <% 
      	        if(!"5000100004000000009".equals(projectType)){
      				  %>
                  <td>其中临时工人数</td>
             	 <%
    			}
    		  %>
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
        
      </div>
  </div>
</body>
<script type="text/javascript">
function frameSize(){
//  $("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
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
var projectType ="<%=projectType%>";

function shenqingAdd(){
    popWindow("<%=contextPath%>/rm/em/toHumanRequiredEdit.srq?projectInfoNo=<%=projectInfoNo%>&projectInfoType=<%=projectType%>",'900:780');   

}

function view_page(ids){		
	if(ids != ""){
		popWindow("<%=contextPath%>/rm/em/toHumanRequiredEdit.srq?projectInfoNo=<%=projectInfoNo%>&projectInfoType=<%=projectType%>&buttonView=false&id="+ids,'900:780');
	}
		
}

function xiugai(){

  ids = getSelectedValue();
  if(ids==''){ 
    alert("请先选中一条记录!");
      return;
  }
  if(ids.split("-")[1] == "1"){
	alert("该需求申请已修改,不能修改");
	return;
  }
  popWindow('<%=contextPath%>/rm/em/toHumanRequiredEdit.srq?projectInfoNo=<%=projectInfoNo%>&projectInfoType=<%=projectType%>&id='+ids.split("-")[0],'900:780');

}

function toDelete(){
  
  ids = getSelectedValue();
  if (ids == '') {
    alert("请选择一条记录!");
    return;
  }   
 
  if(ids.split("-")[1] == "1"){
  	alert("该申请单已提交,不能删除");
  	return;
  }
  
  if (!window.confirm("确认要删除吗?")) {
    return;
  }
  var sql = "update bgp_project_human_requirement set bsflag='1' where requirement_no ='"+ids.split("-")[0]+"'";

  var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
  var params = "deleteSql="+sql;
  params += "&ids="+ids;
  var retObject = syncRequest('Post',path,params);
  refreshData();

}


var selectedTagIndex = 0;
var showTabBox = document.getElementById("tab_box_content0");


function refreshData(){

  cruConfig.queryStr = "select  r.notes proc_status,   decode(r.notes,   '1',  '已提交','待提交') proc_status_name,r.requirement_no, p.project_name, i.org_id, r.apply_company, i.org_name applicant_org_name, r.applicant_id, t2.employee_name applicant_name,      substr(r.SPARE4 ,0,10)apply_date,   To_char(r.create_date, 'yyyy-MM-dd hh24:mi') create_date, r.apply_no from bgp_project_human_requirement r    left join gp_task_project p on r.project_info_no = p.project_info_no   and p.bsflag = '0' left join comm_org_information i on r.apply_company = i.org_id and i.bsflag = '0' left join comm_human_employee t2 on r.applicant_id = t2.employee_id      and t2.bsflag = '0' where r.bsflag = '0' and r.proflag= '0'  and r.project_info_no='<%=projectInfoNo%>'  order by r.create_date desc"; 
  cruConfig.currentPageUrl = "/rm/em/singleHuman/humanRequired/humanRequiredList.jsp";
  queryData(1);
}
 
   
function simpleSearch(){ 
	var s_apply_no = document.getElementById("s_apply_no").value; 	
	 
	if(s_apply_no!=''){		 
		  cruConfig.queryStr = "select   r.notes proc_status,   decode(r.notes,   '1',  '已提交','待提交') proc_status_name,r.requirement_no, p.project_name, i.org_id, r.apply_company, i.org_name applicant_org_name, r.applicant_id, t2.employee_name applicant_name,         substr(r.SPARE4 ,0,10)apply_date,   To_char(r.create_date, 'yyyy-MM-dd hh24:mi') create_date, r.apply_no from bgp_project_human_requirement r   left join gp_task_project p on r.project_info_no = p.project_info_no   and p.bsflag = '0' left join comm_org_information i on r.apply_company = i.org_id and i.bsflag = '0' left join comm_human_employee t2 on r.applicant_id = t2.employee_id      and t2.bsflag = '0' where r.bsflag = '0' and r.proflag= '0'  and r.project_info_no='<%=projectInfoNo%>'  and  r.apply_no like  '%"+s_apply_no+"%'  order by r.create_date desc"; 
		  cruConfig.currentPageUrl = "/rm/em/singleHuman/humanRequired/humanRequiredList.jsp";
		  queryData(1);
		  
	}else{
	refreshData();
	}
	
}
function clearQueryText(){ 
 document.getElementById("s_apply_no").value=''; 
 cruConfig.cdtStr = "";
}


function toSubmit(){
  
  ids = getSelectedValue();
  if (ids == '') {
    alert("请选择一条记录!");
    return;
  }    
  var tempa = ids.split('-');
  var requirement_no =  tempa[0];    
  var prepare_status = tempa[1];		
  
  if(ids.split("-")[1] == "1"){
	  	alert("该申请单已提交,不能提交");
	  	return;
	  }
	  
  if (!window.confirm("确认要提交吗?")) {
    return;
  }
 
	var sql = "update bgp_project_human_requirement t set t.notes='1' ,t.spare4 ='<%=appDate%>'  where t.requirement_no ='"+requirement_no+"'";
	var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
	var params = "sql="+sql;
	params += "&ids="+requirement_no;
	var retObject = syncRequest('Post',path,params);
	
  refreshData();
  
}

    
   function chooseOne(cb){   
          var obj = document.getElementsByName("rdo_entity_id");   
          for (i=0; i<obj.length; i++){   
              if (obj[i]!=cb) obj[i].checked = false;   
              else obj[i].checked = true;   
          }   
      }   
   
   
   
   function loadDataDetail(ids){ 
          
     document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];  	    
     document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0];
     var querySql = " select rownum , (p.plan_end_date-p.plan_start_date + 1) nums,decode(p.age,'0','20-30岁','1','30-40岁','2','40岁以上','') age, decode(p.work_years,'0','3年以下','1','3-5年','2','5-10年','3','10年以上','') work_years, decode(p.culture,'0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他','') culture  ,p.post_no,p.notes,  p.people_number,p.audit_number,p.apply_team,p.post,p.plan_start_date,  p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname from bgp_project_human_post p inner join bgp_project_human_requirement r on p.requirement_no= r.requirement_no left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id  and d1.bsflag='0' and d1.coding_mnemonic_id='<%=projectType%>'  left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id   and d2.bsflag='0' and d2.coding_mnemonic_id='<%=projectType%>' where p.bsflag='0' and p.requirement_no='"+ids.split("-")[0]+"' ";
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
          td.innerHTML = datas[i].apply_teamname;
          
          var td = tr.insertCell(2);
          td.innerHTML = datas[i].postname;

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

