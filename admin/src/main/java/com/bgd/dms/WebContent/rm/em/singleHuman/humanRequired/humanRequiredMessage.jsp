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
  String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();	
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  String appDate = df.format(new Date());
  String folderId = "";
  if(request.getParameter("folderid") != null){
    folderId = request.getParameter("folderid");
  }
  String projectInfoNo =(user==null)?"": user.getProjectInfoNo();
  
  String projectType = (user==null)?"":user.getProjectType();
	String businessType_s="5110000004100000021";
	  if(projectType !=null ){
			if(projectType.equals("5000100004000000008")){
				businessType_s="5110000004100001055";
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
        <td class="ali_cdn_name" >项目名称</td>
	    <td  width="20%">		   
	    <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
	    	<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"  />   
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
		
		 <td  width="35%">		</td>
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
            <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{requirement_no}-{proc_status}' id='rdo_entity_id_{requirement_no}' onclick='doCheck(this)'/>" >选择</td>
            <td class="bt_info_even" autoOrder="1">序号</td>
            <td class="bt_info_odd" exp="<input id='projectName' value='{project_name}' type='hidden'>{project_name}">项目名称</td>
            <td class="bt_info_even" exp="{apply_no}" >单号</td>
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
                  <td>本次申请人数</td>
                  <td>其中临时工人数</td>
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
var org_subjection_idA="<%=orgSubjectionId%>";
var selectedTagIndex = 0;
var showTabBox = document.getElementById("tab_box_content0"); 

function refreshData(){

  cruConfig.queryStr = "select  te.proc_status,   decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) proc_status_name,r.requirement_no, p.project_name, i.org_id, r.apply_company, i.org_name applicant_org_name, r.applicant_id, t2.employee_name applicant_name, To_char(r.apply_date, 'yyyy-MM-dd') apply_date, To_char(r.create_date, 'yyyy-MM-dd hh24:mi') create_date, r.apply_no ,r.project_info_no from bgp_project_human_requirement r   left join common_busi_wf_middle te on    te.business_id=r.requirement_no   and te.bsflag='0'  left join gp_task_project p on r.project_info_no = p.project_info_no   and p.bsflag = '0' left join comm_org_information i on r.apply_company = i.org_id and i.bsflag = '0'  left join comm_org_subjection cosb   on i.org_id=cosb.org_id  and cosb.bsflag='0'  left join comm_human_employee t2 on r.applicant_id = t2.employee_id      and t2.bsflag = '0' where r.bsflag = '0' and r.proflag= '0'      and cosb.org_subjection_id like'"+org_subjection_idA+"%'  order by te.proc_status asc,r.apply_date desc   "; 
  cruConfig.currentPageUrl = "/rm/em/singleHuman/humanRequired/humanRequiredMessage.jsp";
  queryData(1);
}
 
//简单查询
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
 
    
   function chooseOne(cb){   
          var obj = document.getElementsByName("rdo_entity_id");   
          for (i=0; i<obj.length; i++){   
              if (obj[i]!=cb) obj[i].checked = false;   
              else obj[i].checked = true;   
          }   
      }   
   
   function loadDataDetail(ids){
     
      processNecessaryInfo={         
            businessTableName:"bgp_project_human_requirement",    //置入流程管控的业务表的主表表明
            businessType:"<%=businessType_s%>",        //业务类型 即为之前设置的业务大类
            businessId:ids.split("-")[0],         //业务主表主键值
            businessInfo:"物探处人员申请审批",        //用于待审批界面展示业务信息
            applicantDate:'<%=appDate%>'       //流程发起时间
          }; 
          processAppendInfo={ 
              projectInfoNo:'<%=projectInfoNo%>',
              id: ids.split("-")[0],
              buttonView:"false",
          	projectName:'<%=user.getProjectName()%>'
     
          };   
          
     document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids.split("-")[0];  	    
     document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+ids.split("-")[0];
     var querySql = " select rownum , (p.plan_end_date-p.plan_start_date) nums,decode(p.age,'0','20-30岁','1','30-40岁','2','40岁以上','') age, decode(p.work_years,'0','3年以下','1','3-5年','2','5-10年','3','10年以上','') work_years, decode(p.culture,'0','博士研究生','1','硕士研究生','2','大学本科以上','3','大学专科(高职)以上','4','中专','5','技校','6','高中以上','7','初中以上','8','小学以上','9','其他','') culture  ,p.post_no,p.notes,  p.people_number,p.audit_number,p.apply_team,p.post,p.plan_start_date,  p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname from bgp_project_human_post p inner join bgp_project_human_requirement r on p.requirement_no= r.requirement_no left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id  left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id  where p.bsflag='0' and p.requirement_no='"+ids.split("-")[0]+"' ";
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
          td.innerHTML = datas[i].audit_number;
                                                 
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

