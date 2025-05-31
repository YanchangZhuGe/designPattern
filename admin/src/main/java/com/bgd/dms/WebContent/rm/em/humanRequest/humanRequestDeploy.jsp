<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%> 
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
 

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request); 
	
	String orgSubjectionId = (user==null)?"":user.getSubOrgIDofAffordOrg();	
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

  <title>������Ա����ҳ��</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			    <tr>
			    <td  class="ali_cdn_name">	 ��Ŀ����   </td>
				    <td  width="20%">		    
				    <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
	  		    	<input name="s_project_name" id="s_project_name" class="input_width" value="" type="text"   />   
	  			    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   
	  			     </td>
	  			   <td class="ali_cdn_name">����״̬</td>
				    <td  width="20%">
				    <select name="s_proc_status" id="s_proc_status" class="select_width" >
				    <option value="">��ѡ��</option>
				    <option value="0">������</option>
				    <option value="1">������</option>
				    <option value="2">�ѵ���</option>    
				    </select>			     
				    </td>
				    <td class="ali_query">
			    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
		    		</td>
				    <td class="ali_query">
					    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
					</td>
					
				    <td width="25%">&nbsp;</td>
				 
				    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
				    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
				    <auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
				    <auth:ListButton functionId="F_HUMAN_0013" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
				  
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
			      <td class="bt_info_odd" 	 exp="<input type='checkbox' name='chx_entity_id'  id='chx_entity_id{requirement_no}' value='{requirement_no},{prepare_status},{prepare_no},{notice_user_id},{notice_user_name},{notice_way},{prepare_id},{employee_name},{org_id},{project_type},{project_info_no},{notes}' onclick='chooseOne(this);'  \>">ѡ��</td>
					<td class="bt_info_even" 	 exp=" {apply_no}">���뵥��</td>
					<td class="bt_info_odd" 	 exp="{prepare_status_name}" >����״̬</td>
					<td class="bt_info_even" 	 exp="{project_name}">��Ŀ����</td>
					<td class="bt_info_odd" 	 exp="{applicant_name}">������</td>
					<td class="bt_info_even" 	 exp="{applicant_org_name}">���뵥λ</td>
					<td class="bt_info_odd" 	 exp="{apply_date}">����ʱ��</td>
					<td class="bt_info_even" 	 exp="{prepare_id}">���䵥��</td>
					<td class="bt_info_odd" 	 exp="{deploy_date}">����ʱ��</td>
					<td class="bt_info_even" 	 exp="{employee_name}">������</td>  
			     </tr> 			        
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">��1/1ҳ����0����¼</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">�� 
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">�����λ</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">������Ա</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">����</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">��ע</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="professDetailList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
				    	      
			        </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table id="humanInfoList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;">
		    	<tr class="bt_info">
		    	    <td>���</td>
		            <td>����</td>
		            <td>��λ</td>
		            <td>����</td>
		            <td>�ƻ�������Ŀʱ��</td>
		            <td>�ƻ��뿪��Ŀʱ��</td>
		            <td>Ԥ������Ŀ����</td>		     
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

	 jcdpCallService("HumanRequiredSrv","submitHumanPrepare","");	
	function toAdd(){
		 ids = getSelectedValue();
	    if(ids==''){ alert("����ѡ��һ����¼!");
	     return;
	    } 
	    var tempa = ids.split(',');		    
	    var prepare_status = tempa[1];
	    var requirement_no =  tempa[0];
	    var prepare_no =  tempa[2];
	    var project_type= tempa[9]; 	
	    var projectInfoNo_s= tempa[10]; 
	    
/* 	    var notes= tempa[11]; 
	    if(notes == 'detailAdd'){
	    	alert('���ݲ������!');
	    	return;
	    } */
	    
	    
	    if(prepare_status == 1 ){
	         alert("�õ��䵥�Ѵ��ڵ����У����ܽ�������!");
	    		return;
	     	    	
	    }
	    if(prepare_status == 2 ){
	        if(!window.confirm("�õ��䵥�ѵ��䣬��������µĵ��䣬��ѡ��ȷ����������ȡ��!")) {
	    		return;
	    	}
	    	popWindow('<%=contextPath%>/rm/em/toHumanPrepareEdit.srq?id='+requirement_no+'&func=2&project_type='+project_type+'&projectInfoNo='+projectInfoNo_s,'1150:750');
	    }
	    
	    if(prepare_status == 0 ){
	    	if(prepare_no!=''){
	    		popWindow('<%=contextPath%>/rm/em/toHumanPrepareEdit.srq?id='+requirement_no+'&func=0&addF='+prepare_no+'&project_type='+project_type+'&projectInfoNo='+projectInfoNo_s,'1150:750');
	    	}else{
	    		popWindow('<%=contextPath%>/rm/em/toHumanPrepareEdit.srq?id='+requirement_no+'&func=0&project_type='+project_type+'&projectInfoNo='+projectInfoNo_s,'1150:750');
	      		
	    	} 
	     	    	
	    }
	
	
	}
	
	function toEdit(){
		  ids = getSelectedValue();
	    if(ids==''){ alert("����ѡ��һ����¼!");
	     return;
	    } 
	    var tempa = ids.split(',');		
	    var requirement_no =  tempa[0];    
	    var prepare_status = tempa[1];		    		  
	    var prepare_no =  tempa[2];
	    var project_type= tempa[9]; 
	    var projectInfoNo_s= tempa[10]; 
	    var notes= tempa[11]; 
	    if(notes == 'detailAdd'){
	    	alert('���ݲ����޸�!');
	    	return;
	    }
	    if(prepare_status == 2 ){
	        alert("�õ��䵥���ύ�����޸�!");
	    	return;
	    }
		if(prepare_status == 0 ){
	        alert("�õ��䵥δ����,���ȵ���!");
	    	return;
	    }
		if(prepare_no != ''){
			popWindow("<%=contextPath%>/rm/em/toHumanPrepareEdit.srq?id="+requirement_no+"&update=true"+"&prepareNo="+prepare_no+"&func=1&project_type="+project_type+"&projectInfoNo="+projectInfoNo_s,"1150:750");
		}	
	}
	
	function toDelete(){
		 ids = getSelectedValue();
	    if(ids==''){ alert("����ѡ��һ����¼!");
	     return;
	    } 

	    var tempa = ids.split(',');
	    
	    var requirement_no =  tempa[0];    
	    var prepare_status = tempa[1];		    		  
	    var prepare_no =  tempa[2];
	    var notice_user_id =  tempa[3];    
	    var notice_user_name = tempa[4];		    		  
	    var notice_way =  tempa[5];
	    var prepare_id =  tempa[6];
	    var employee_name =  tempa[7];
	    var apply_company =  tempa[8];

	    if(prepare_status == 2){
	    	alert("�õ������ύ,������ɾ��");
	    	return;
	    }
		if(prepare_status == 0 ){
	        alert("�õ��䵥δ����!");
	    	return;
	    }

		//�ı��˵�״̬��ɾ�������е�״̬
		jcdpCallService("HumanRequiredSrv","deleteHumanPrepareFlag","prepareNo="+prepare_no+"&applyCompany="+apply_company+"&func=1");
		var sql = "update bgp_human_prepare set bsflag='1' where prepare_no ='"+prepare_no+"'";
		deleteEntities(sql);
		
	}
	
	function toSubmit(){
		
		ids = getSelectedValue();
	    if(ids==''){ alert("����ѡ��һ����¼!");
	     return;
	    } 

	    var tempa = ids.split(',');
	    
	    var requirement_no =  tempa[0];    
	    var prepare_status = tempa[1];		    		  
	    var prepare_no =  tempa[2];
	    var notice_user_id =  tempa[3];    
	    var notice_user_name = tempa[4];		    		  
	    var notice_way =  tempa[5];
	    var prepare_id =  tempa[6];
	    var employee_name =  tempa[7];
	    var apply_company =  tempa[8];

	    if(prepare_status == 2){
	    	alert("�õ������ύ,�������ٴ��ύ");
	    	return;
	    }
		if(prepare_status == 0 ){
	        alert("�õ��䵥δ����,���ȵ���!");
	    	return;
	    }

		if (!window.confirm("ȷ��Ҫ�ύ��?")) {
			return;
		}
		var sql = "update bgp_human_prepare t set t.prepare_status='2' where t.prepare_no ='"+prepare_no+"'";
		var path = cruConfig.contextPath+"/rad/asyncUpdateEntitiesBySql.srq";
		var params = "sql="+sql;
		params += "&ids="+ids.split(",")[1];
		var retObject = syncRequest('Post',path,params);
			
 		var querySql1 = "select rownum,t.* from (select  t.human_detail_no,	     hre.employee_hr_id,  t.team, 	  t.work_post,     t.employee_id,    e.employee_name,    t.plan_start_date, t.plan_end_date, (t.plan_end_date- t.plan_start_date + 1) plan_days, (t.actual_end_date- t.actual_start_date + 1) actual_days, t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name, t.actual_end_date,t.spare1,t.notes  from bgp_human_prepare_human_detail t inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0'  left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id        left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id           left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'      left join comm_human_employee_hr hre   on t.employee_id=hre.employee_id    and hre.bsflag='0'   where t.prepare_no='"+prepare_no+"'   union all select distinct     t.labor_deploy_id as human_detail_no ,  t.labor_id as employee_hr_id,d2.apply_team as team, d2.post as work_post ,  t.labor_id as employee_id,   l.employee_name,   t.start_date as plan_start_date ,  t.spare4 as  plan_end_date,  (t.spare4 - t.start_date + 1) plan_days,    (t.end_date -  t.actual_start_date + 1) actual_days,    t.actual_start_date,  d3.coding_name team_name,  d4.coding_name work_post_name,    t.end_date as actual_end_date,   t.spare1,  t.notes        from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2     on t.labor_deploy_id = d2.labor_deploy_id    and d2.bsflag = '0'   left join bgp_comm_human_labor l     on t.labor_id = l.labor_id    left join comm_coding_sort_detail d3     on d2.apply_team = d3.coding_code_id   left join comm_coding_sort_detail d4     on d2.post = d4.coding_code_id    where t.bsflag = '0'  and   t.spare1= '"+prepare_no+"' ) t ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		if(datas1 != null){	 
		     for (var i = 0; i< queryRet1.datas.length; i++) {    
 				var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';	       	
   				var submitStr = 'JCDP_TABLE_NAME=COMM_HUMAN_EMPLOYEE_HR&JCDP_TABLE_ID='+datas1[i].employee_hr_id +'&deploy_status=2&person_status=1&modifi_date=<%=curDate%>';
   			    syncRequest('Post',paths,encodeURI(encodeURI(submitStr)));  //�ύ��Ա���䵥��ͬʱ���� ��Ա���е� ����״̬���ѵ��䡱	person_status1Ϊ����Ŀ	
   			    var submitStrL = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_LABOR&JCDP_TABLE_ID='+datas1[i].employee_hr_id +'&spare1=2&if_project=1&modifi_date=<%=curDate%>';
			    syncRequest('Post',paths,encodeURI(encodeURI(submitStrL)));  //�ύ��Ա���䵥��ͬʱ���� ��ʱ�����е� ����״̬���ѵ��䡱		

		     } 
		}
		
//		submitProcessInfo();
		refreshData();

		
	}
	
    
	   function chooseOne(cb){   
	          var obj = document.getElementsByName("chx_entity_id");   
	          for (i=0; i<obj.length; i++){   
	              if (obj[i]!=cb) obj[i].checked = false;   
	              else obj[i].checked = true;   
	          }   
	      }   
	   
	   
	   
	
	// �򵥲�ѯ
	function simpleSearch(){
		
		var s_project_info_no = document.getElementById("s_project_name").value;
		var s_proc_status = document.getElementById("s_proc_status").value;

		var str = " 1=1 ";
		
		if(s_project_info_no!=''){			
			str += "  and  project_name like '%"+s_project_info_no+"%' ";						
		}	
		if(s_proc_status!=''){			
			str += " and prepare_status like '"+s_proc_status+"%' ";						
		}
		
		cruConfig.cdtStr = str;
		refreshData();
	}
	
	function clearQueryText(){
		document.getElementById("s_project_info_no").value="";
		document.getElementById("s_project_name").value="";
		document.getElementById("s_proc_status").value="";
	}
	function refreshData(){

		cruConfig.queryStr = " select *  from (select   pr.notes, r.apply_no, decode(te.proc_status,   '1',   '������',  '3',  '����ͨ��', '4', '������ͨ��',te.proc_status) proc_status_name, te.proc_status,  r.requirement_no,      p.project_type,   p.project_name,        t2.employee_name applicant_name,        i.org_id,        i.org_abbreviation applicant_org_name,    To_char(r.apply_date, 'yyyy-MM-dd') apply_date,        pr.prepare_no,        pr.prepare_id,        pr.applicant_id,        t1.employee_name,         To_char(pr.deploy_date, 'yyyy-MM-dd') deploy_date,        nvl(pr.prepare_status,'0') prepare_status,        decode(pr.prepare_status,'0','������','1','������','2','�ѵ���','������') prepare_status_name ,    r.project_info_no  from bgp_project_human_requirement r    join gp_task_project p on r.project_info_no = p.project_info_no                              and p.bsflag = '0'   left join bgp_human_prepare pr on r.requirement_no = pr.requirement_no and pr.bsflag='0'   left join common_busi_wf_middle te on    te.business_id=pr.prepare_no  and te.business_type='5110000004100000020' and te.bsflag='0' left join common_busi_wf_middle te1 on  te1.business_id=r.requirement_no  and te1.business_type  in ('5110000004100000021','5110000004100001055') and te1.bsflag='0' left join comm_org_information i on r.apply_company = i.org_id and i.bsflag = '0'   left join comm_org_subjection cosb   on i.org_id=cosb.org_id  and cosb.bsflag='0'  left join comm_human_employee t1 on pr.applicant_id = t1.employee_id                                   and t1.bsflag = '0'   left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0'   "
			+" where r.bsflag = '0'   and cosb.org_subjection_id like'"+org_subjection_idA+"%'  and te1.proc_status='3'  union all select   pr.notes, r.apply_no, decode(te.proc_status,   '1',   '������',  '3',  '����ͨ��', '4', '������ͨ��',te.proc_status) proc_status_name, te.proc_status,  r.requirement_no,      p.project_type,   p.project_name,        t2.employee_name applicant_name,        i.org_id,        i.org_abbreviation applicant_org_name,    To_char(r.apply_date, 'yyyy-MM-dd') apply_date,        pr.prepare_no,        pr.prepare_id,        pr.applicant_id,        t1.employee_name,         To_char(pr.deploy_date, 'yyyy-MM-dd') deploy_date,        nvl(pr.prepare_status,'0') prepare_status,        decode(pr.prepare_status,'0','������','1','������','2','�ѵ���','������') prepare_status_name ,    r.project_info_no  from bgp_project_human_requirement r    join gp_task_project p on r.project_info_no = p.project_info_no                              and p.bsflag = '0'   left join bgp_human_prepare pr on r.requirement_no = pr.requirement_no and pr.bsflag='0'   left join common_busi_wf_middle te on    te.business_id=pr.prepare_no  and te.business_type='5110000004100000020' and te.bsflag='0'  left join comm_org_information i on r.apply_company = i.org_id and i.bsflag = '0'   left join comm_org_subjection cosb   on i.org_id=cosb.org_id  and cosb.bsflag='0'  left join comm_human_employee t1 on pr.applicant_id = t1.employee_id                                   and t1.bsflag = '0'   left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0'  where r.bsflag = '0'   and cosb.org_subjection_id like'"+org_subjection_idA+"%'  and r.notes='1'   )   order by  prepare_status asc,apply_date desc ";
		cruConfig.currentPageUrl = "/rm/em/humanRequest/humanRequestDeploy.jsp";
		queryData(1);
		
	}
		
	//ѡ����Ŀ
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
    	 var tempa = ids.split(',');
 	    
 	    var requirement_no =  tempa[0];    
	    var prepare_no =  tempa[2]; 
	    var updates='true';
	    var funcs='1';
//	    processNecessaryInfo={         
//	    		businessTableName:"BGP_HUMAN_PREPARE",    //�������̹ܿص�ҵ�����������
//	    		businessType:"5110000004100000020",        //ҵ������ ��Ϊ֮ǰ���õ�ҵ�����
//	    		businessId:prepare_no,         //ҵ����������ֵ
//	    		businessInfo:"��Ա���������������",        //���ڴ���������չʾҵ����Ϣ
//	    		applicantDate:'<%=appDate%>'       //���̷���ʱ��
//	    	}; 
//	    	processAppendInfo={ 
//	    			id: requirement_no,
//	    			prepareNo: prepare_no,
//	    			update: updates,
//	    			func: funcs  	   				 
//	    	};   

	  	document.getElementById("attachement").src = "<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+prepare_no;
		    
		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+prepare_no;
	    	
 		var querySql = "select rownum,t.* from (select  p.spare2,p.spare3,p.apply_team,p.people_number,p.audit_number,d1.coding_name apply_team_name,p.post,d2.coding_name post_name,  p.plan_start_date,p.plan_end_date,(p.plan_end_date-p.plan_start_date + 1 ) nums,decode(p.age,'0','20-30��','1','30-40��','2','40������','') age, decode(p.work_years,'0','3������','1','3-5��','2','5-10��','3','10������','') work_years, decode(p.culture,'0','��ʿ�о���','1','˶ʿ�о���','2','��ѧ��������','3','��ѧר��(��ְ)����','4','��ר','5','��У','6','��������','7','��������','8','Сѧ����','9','����','') culture  from bgp_project_human_post p left join comm_coding_sort_detail d1 on p.apply_team=d1.coding_code_id and d1.bsflag='0' left join comm_coding_sort_detail d2 on p.post=d2.coding_code_id and d2.bsflag='0' where p.requirement_no='"+requirement_no+"' and p.bsflag='0' order by p.apply_team )t ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
 		var querySql1 = "select rownum,t.* from (select  t.human_detail_no,		  t.team, 	  t.work_post,     t.employee_id,    e.employee_name,    t.plan_start_date, t.plan_end_date, (t.plan_end_date- t.plan_start_date + 1) plan_days, (t.actual_end_date- t.actual_start_date + 1) actual_days, t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name, t.actual_end_date,t.spare1,t.notes  from bgp_human_prepare_human_detail t inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0'  left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id        left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id           left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'  where t.prepare_no='"+prepare_no+"'   and t.bsflag='0'   union all select distinct     t.labor_deploy_id as human_detail_no , d2.apply_team as team, d2.post as work_post ,  t.labor_id as employee_id,   l.employee_name,   t.start_date as plan_start_date ,  t.spare4 as  plan_end_date,  (t.spare4 - t.start_date + 1) plan_days,    (t.end_date -  t.actual_start_date + 1) actual_days,    t.actual_start_date,  d4.coding_name work_post_name, d3.coding_name team_name,     t.end_date as actual_end_date,   t.spare1,  t.notes        from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2     on t.labor_deploy_id = d2.labor_deploy_id    and d2.bsflag = '0'   left join bgp_comm_human_labor l     on t.labor_id = l.labor_id    left join comm_coding_sort_detail d3     on d2.apply_team = d3.coding_code_id   left join comm_coding_sort_detail d4     on d2.post = d4.coding_code_id    where t.bsflag = '0'  and   t.spare1= '"+prepare_no+"' ) t ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		
	
//		loadProcessHistoryInfo();
	    var project_type= tempa[9];  

		 if(project_type!="5000100004000000009"){ 
		 deleteTableTrs("professDetailList"); 
			var trt = document.getElementById("professDetailList").insertRow();	
			trt.className = "bt_info";
			var td = trt.insertCell(0);
			td.innerHTML ="���";
			
			var td = trt.insertCell(1);
			td.innerHTML = "����";
			
			var td = trt.insertCell(2);
			td.innerHTML = "��λ";

			var td = trt.insertCell(3);
			td.innerHTML = "������������";
			var td = trt.insertCell(4);
			td.innerHTML = "������ʱ������";
			
			var td = trt.insertCell(5);
			td.innerHTML = "�ƻ�������Ŀʱ��";
			
			var td = trt.insertCell(6);
			td.innerHTML ="�ƻ��뿪��Ŀʱ��";
			
			var td = trt.insertCell(7);
			td.innerHTML ="Ԥ������Ŀ����";
			
			var td = trt.insertCell(8);
			td.innerHTML = "����";
			
			var td = trt.insertCell(9);
			td.innerHTML ="��������";
			
			var td = trt.insertCell(10);
			td.innerHTML = "�Ļ��̶�";	
		 }else{
			 deleteTableTrs("professDetailList"); 
				var trt = document.getElementById("professDetailList").insertRow();	
				trt.className = "bt_info";
				var td = trt.insertCell(0);
				td.innerHTML ="���";
				
				var td = trt.insertCell(1);
				td.innerHTML = "����";
				
				var td = trt.insertCell(2);
				td.innerHTML = "��λ";

				var td = trt.insertCell(3);
				td.innerHTML = "������������";
				var td = trt.insertCell(4);
				td.innerHTML = "�ƻ�������Ŀʱ��";
				
				var td = trt.insertCell(5);
				td.innerHTML ="�ƻ��뿪��Ŀʱ��";
				
				var td = trt.insertCell(6);
				td.innerHTML ="Ԥ������Ŀ����";
				
				var td = trt.insertCell(7);
				td.innerHTML = "����";
				
				var td = trt.insertCell(8);
				td.innerHTML ="��������";
				
				var td = trt.insertCell(9);
				td.innerHTML = "�Ļ��̶�";	 
			 
		 }
		 
		
			deleteTableTr("professDetailList"); 
			deleteTableTr("humanInfoList");
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
				 if(project_type!="5000100004000000009"){
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
				 }else{
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
		
		
		if(datas1 != null){	 
	     for (var i = 0; i< queryRet1.datas.length; i++) {
			
				var tr = document.getElementById("humanInfoList").insertRow();		
				
	        	if(i % 2 == 1){  
	          		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
              	
            	var td = tr.insertCell(0);
				td.innerHTML = datas1[i].rownum;
				
				var td = tr.insertCell(1);
				td.innerHTML = datas1[i].team_name;
				
				var td = tr.insertCell(2);
				td.innerHTML = datas1[i].work_post_name;

				var td = tr.insertCell(3);
				td.innerHTML = datas1[i].employee_name;

				var td = tr.insertCell(4);
				td.innerHTML = datas1[i].plan_start_date;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas1[i].plan_end_date;
				var td = tr.insertCell(6);
				td.innerHTML = datas1[i].plan_days;
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
	function deleteTableTrs(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=0;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	
	
	
</script>
</html>