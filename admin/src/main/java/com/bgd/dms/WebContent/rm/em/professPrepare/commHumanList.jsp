<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getOrgSubjectionId();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/cn/style.css" />
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/table.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/rt_list_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/rt_search_var.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cute/rt_list_new.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/updateListTable.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cute/kdy_search.js"></script>
<script type="text/javascript">
   var pageTitle = "��Ա������Ϣ�б�"; 
   cruConfig.contextPath = "<%=contextPath%>";
   
	cruConfig.cdtType = 'form';
	cruConfig.queryService = "HumanCommInfoSrv";
	cruConfig.queryOp = "searchforHumanInfo";
		
	var jcdp_codes_items = null;
	var jcdp_codes = new Array();
	
	function page_init() {
		var titleObj = getObj("cruTitle");
		if (titleObj != undefined)
			titleObj.innerHTML = pageTitle;
//		cruConfig.queryStr = "select hr.employee_cd, e.employee_id, e.org_id, e.employee_name, decode(e.employee_gender, '0', 'Ů', '1', '��') employee_gender_name, (to_char(sysdate, 'YYYY') - to_char(e.employee_birth_date, 'YYYY')) age, hr.work_date, i.org_abbreviation org_name, hr.post, hr.post_level, d1.coding_name post_level_name, e.employee_education_level, d2.coding_name employee_education_level_name, s.org_subjection_id,e.modifi_date from comm_human_employee e inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' left join comm_org_information i on e.org_id = i.org_id and i.bsflag = '0' left join comm_coding_sort_detail d1 on hr.post_level = d1.coding_code_id and d1.bsflag = '0' left join comm_coding_sort_detail d2 on e.employee_education_level = d2.coding_code_id and d2.bsflag = '0' where e.bsflag = '0' and hr.bsflag='0' and s.org_subjection_id like '<%=orgSubId%>' || '%' order by e.modifi_date desc";
		cruConfig.currentPageUrl = "/rm/em/commHumanInfo/commHumanList.lpmd";
		queryData(1);
	}
	
	
	//�����checkboxƴ�ӵ�ֵ
	var checked="";

	function doCheck(id){

		//���
		var num = -1;
		//�µ�checkֵ
		var newcheck = "";
		//ƴ�ӵ�ֵ��Ϊ��

		if(checked != ""){
			var checkStr = checked.split(",");
			for(var i=0;i<checkStr.length-1; i++){
				//���check�д���  ѡ���idֵ
				if(checkStr[i] == id.value){
					//��¼λ��
					num = i;		
					break;	
				}
			}
	        //�ж�num�Ƿ���ֵ
			if(num != -1 ){
				if(id.checked==false){
					for(var j=0;j<checkStr.length-1; j++){
						if( j != num ){
							newcheck += checkStr[j] + ',';
						}
					}
					checked = newcheck;
				}
			}else{
				//ֱ��ƴ
				if(id.checked==true){
					checked= checked + id.value + ',';	
				}		
			}
		}else{
			checked = id.value + ',';
			
		}
		

	}

	function head_chx_box_changed(headChx){
		var chxBoxes = document.getElementsByName("chx_entity_id");
		if(chxBoxes==undefined) return;
		for(var i=0;i<chxBoxes.length;i++){
		  if(!chxBoxes[i].disabled){
				chxBoxes[i].checked = headChx.checked;	
				doCheck(chxBoxes[i]);
		  }
		  
		}
	}
	

	function JcdpButton0OnClick(){
		if(checked == ""){
			alert("��ѡ��һ����¼!");
			return;
		}
		window.returnValue = checked;
		window.close();  
	}

	function JcdpButton1OnClick(){
		window.returnValue = "";
		window.close(); 
	}

</script>
  <title>�б�ҳ��</title> 
 </head> 
 <body class="bgColor" onload="page_init();">  
  <div class="dataList wrap"> 
   <div class="tt"> 
    <h2 id="cruTitle">�����б�</h2> 
   </div> 
   <div class="ctt"> 
   
    <div id="buttonDiv" class="ctrlBtn"> 
     <input id=" " type="button" value="�ύ" onclick="JcdpButton0OnClick()" style="" /> 
     <input id=" " type="button" value="����" onclick="JcdpButton1OnClick()" style="" /> 

    </div> 
    <div class="pageNumber" id="pageNumDiv"> 
     <a href="#" class="first fl"></a> 
     <a href="#" class="prev fl"></a> 
     <div class="pageNumber_cur fl" id="dataRowHint">
       �� 
      <input id="changePage" type="text" size="2" onkeydown="javascript:changePage()" /> ҳ �� 5 ҳ 
     </div> 
     <a href="#" class="next fl"></a> 
     <a href="#" class="last fl"></a> 
     <div class="clear"></div> 
    </div> 
    <!--end table_pageNumber--> 
    <!--Remark ��ѯ�����ʾ����--> 
    <div class="tableWrap"> 
     <table id="queryRetTable" class="table_list" cellpadding="0" cellspacing="0"> 
      <tr>
       <th exp="<input type='checkbox' name='chx_entity_id' value='{employeeId}-{employeeName}' onclick=doCheck(this) >" ><input type='checkbox' id='headChxBox' onclick="head_chx_box_changed(this)"></th>
       <th exp="{employeeCd}">���</th>
       <th exp="{employeeName}">����</th>      
       <th exp="{employeeGenderName}">�Ա�</th>      
       <th exp="{age}">����</th>
       <th exp="{orgAbbreviation}">��֯����</th>
       <th exp="{reliefOrgName}">���䵥λ</th>
       <th exp="{post}">��λ</th>
       <th exp="{setTeamName}">���ð���</th>
       <th exp="{setPostName}">���ø�λ</th>
       <th exp="{workAge}">��������</th>
       <th exp="{personStatus}">��Ա״̬</th>
       <th exp="{planEndDate}">Ԥ���뿪��Ŀʱ��</th>
       <th exp="{deployStatusName}">����״̬</th>
       <th exp="{actualStartDate}">���һ�ν�����Ŀʱ��</th>
       <th exp="{actualEndDate}">���һ���뿪��Ŀʱ��</th>
       <th exp="{projectName}">���һ���ϸ���Ŀ����</th>
      </tr>
     </table> 
    </div> 
    <!--end table_body--> 
   </div> 
   <!--end ctt--> 
  </div> 
  <!--end dataList--> 
  
 </body>
</html>