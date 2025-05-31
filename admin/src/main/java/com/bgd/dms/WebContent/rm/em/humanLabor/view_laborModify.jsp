<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html>
 <head> 
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/JCDP_SAIS_CSS/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/JCDP_SAIS_JS/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/JCDP_SAIS_JS/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_view.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript">
   var cruTitle = "JCDP_title_view--��ʱ��CRU";
   var eliteIf = new Array( ['0','��'],['1','��'] ); 
   var xiangmuIf = new Array( ['0','������Ŀ'],['1','����Ŀ'] ); 
   var nationOps = new Array( ['01','��'],['02','��'],['03','��'],['04','��'],['05','׳'],['05','ά'],['99','����'] ); 
   var genderOps = new Array( ['1','��'],['0','Ů'] ); 
   var degreeOps = new Array( ['0','����'],['1','˶ʿ'],['2','��ʿ'],['3','����'] ); 
   var jcdp_codes_items = null; 
   var jcdp_codes = new Array(['engineerCode','�ù�����',"select t.coding_code_id AS value, t.coding_name AS label,t.coding_show_id as coding_show_id from comm_coding_sort_detail t where t.coding_sort_id ='0110000059' and t.bsflag='0'",""], ['teamCode','����',"SELECT t.coding_code_id AS value, t.coding_name AS label from comm_coding_sort_detail t where t.coding_sort_id ='0110000001' and t.bsflag='0' and length(t.coding_code) = 2 order by t.coding_show_id",""], ['postCode','��λ',"select t.coding_code_id AS value, t.coding_name AS label,t.coding_show_id as coding_show_id from comm_coding_sort_detail t where t.coding_sort_id ='0500100011' and t.bsflag='0'",""]);  
   var jcdp_record = null; 
   
   /** ���ֶ�Ҫ��������ݿ����*/
   var tables = new Array(['bgp_comm_human_labor'] ,['bgp_comm_human_labor_deploy'] ); 
   var defaultTableName = 'bgp_comm_human_labor'; 
   /**0�ֶ�����1��ʾlabel��2�Ƿ���ʾ��༭��Hide,Edit,ReadOnly�� 3�ֶ����ͣ�TEXT(�ı�),N(����),NN(����),D(����),EMAIL,ET(Ӣ��)�� MEMO(��ע)��SEL_Codes(�����),SEL_OPs(�Զ��������б�) ��FK(�����)�� 4������볤�ȣ� 5Ĭ��ֵ��'CURRENT_DATE'��ǰ���ڣ�'CURRENT_DATE_TIME'��ǰ����ʱ�䣬 ����Ĭ��ֵ 6�����ĳ��ȣ�7�������Զ������ֵ�򵯳�ҳ������ӣ�8 �Ƿ�ǿգ�ȡֵΪnon-empty�����������* 9 Column Name��10 Event,11 Table Name*/
   var fields = new Array(
		   ['labor_id','Id','Hide','TEXT',,,,,,,],
		   ['employee_name','����','Edit','TEXT',,,,,'non-empty',,],
		   ['employee_gender','�Ա�','Edit','SEL_OPs',,,,genderOps,'non-empty',,],
		   ['employee_birth_date','��������','Edit','D',,,,,'non-empty',,],
		   ['employee_nation','����','Edit','SEL_OPs',,,,nationOps,'non-empty',,],
		   ['employee_id_code_no','���֤��','Edit','TEXT',,,,,'non-empty',,],
		   ['employee_education_level','�Ļ��̶�','Edit','SEL_OPs',,,,degreeOps,,,],
		   ['employee_address','��ͥסַ','Edit','TEXT',,,,,,,],
		   ['phone_num','��ϵ�绰','Edit','TEXT',,,,,'non-empty',,],
		   ['employee_health_info','������Ϣ','Edit','TEXT',,,,,,,],
		   ['elite_if','�Ƿ�Ǹ�','Edit','SEL_OPs',,,,eliteIf,,,],
		   ['apply_team','����','Edit','SEL_Codes',,,,,,,'onchange=changePost()'],
		   ['post','��λ','Edit','SEL_Codes',,,,,,,],
		   ['workerfrom','�ù���Դ','Edit','FK',,'$ENTITY.df_workerfrom:$ENTITY.df_workerfrom_name',,'selectCode.jsp?codingSortId=0110000025',,,],
		   ['technical_title','����ְ��','Edit','FK',,'$ENTITY.technical_title:$ENTITY.technical_title_name',,'selectCode.jsp?codingSortId=0500100008',,,],
		   ['null','�ֻ�����','Edit','TEXT',,,,,'non-empty',,],
		   ['null','��Ŀ״̬','Edit','SEL_OPs',,,,xiangmuIf,,,],
		   ['owning_org_id','��֯����','Edit','FK',,'$ENTITY.org_id:$ENTITY.org_name',,'selectOrg.jsp?codingSortId=0110000001',,,],
		   ['owning_subjection_org_id','��֯����������ϵ','Edit','TEXT',,,,,,,],
		   ['null','�ù�����','Edit','TEXT',,,,,,,],
		   ['null','�ʱ�','Edit','TEXT',,,,,,,],
		   ['null','�Ͷ���ͬ���','Edit','TEXT',,,,,,,],
		    ['specialty','����','Edit','MEMO','1000',,,,,,],
		   ['bsflag','','Hide','TEXT',,'0',,,,,],
		   ['updator','�޸���','Hide','TEXT',,'<%=user.getUserId()%>',,,,,],
		   ['modifi_date','�޸�ʱ��','Hide','D',,'CURRENT_DATE_TIME',,,,,]);
   var uniqueFields = ':'; 
   var fileFields = ':'; 
   function page_init()
   {  setCruTitle();
   cruConfig.contextPath = "<%=contextPath%>"; 
   cruConfig.querySql = "select rownum, l.labor_id, l.employee_name, l.post, l.apply_team, d3.coding_name posts, d4.coding_name apply_teams, l.employee_nation, d1.coding_name employee_nation_name, l.employee_gender, l.owning_org_id, l.owning_subjection_org_id, decode(l.employee_gender, '0', 'Ů', '1', '��', l.employee_gender) employee_gender_name, decode(nvl(l.if_project, 0), '0', '������Ŀ', '1', '����Ŀ', l.if_project) if_project_name, l.if_project, l.if_engineer, d5.coding_name if_engineer_name, l.cont_num, l.employee_birth_date, l.employee_id_code_no, l.employee_education_level, d2.coding_name employee_education_level_name, l.employee_address, l.phone_num, l.employee_health_info, l.specialty, l.elite_if, l.workerfrom, lt.list_id, case when lt.list_id is null then '' else '�鿴' end fsflag, case when lt.list_id is null then '' else 'red' end bgcolor, nvl(t.years, 0) years from bgp_comm_human_labor l left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id and lt.bsflag = '0' left join comm_coding_sort_detail d1 on l.employee_nation = d1.coding_code_id left join comm_coding_sort_detail d2 on l.employee_education_level = d2.coding_code_id left join comm_coding_sort_detail d3 on l.post = d3.coding_code_id left join comm_coding_sort_detail d4 on l.apply_team = d4.coding_code_id left join comm_coding_sort_detail d5 on l.if_engineer = d5.coding_code_id left join comm_org_subjection cn on l.owning_org_id = cn.org_id left join (select count(distinct to_char(t.start_date, 'yyyy')) years, t.labor_id from bgp_comm_human_labor_deploy t group by t.labor_id) t on l.labor_id = t.labor_id where l.labor_id = 'null'"; 
   cru_init(); } 
   function submitFunc(){ 
	   var submitStr = "jcdp_tables="+JSON.stringify(tables);
	   for(var i=0;i<tables.length;i++){ 
		   var tableName = tables[i][0];  
		   var tSubmitStr = ''; 
		   if(tableName==defaultTableName) 
			   tSubmitStr = getSubmitStr(); 
		   else tSubmitStr = getSubmitStr(tableName);
		   if(tSubmitStr == null) return;  
		   submitStr += "&"+tableName+"="+JSON.stringify(submitStr2Array(tSubmitStr));  } 
	   var path = cruConfig.contextPath+cruConfig.updateMulTableAction; 
	   var retObject = syncRequest('Post',path,submitStr);  afterSubmit(retObject); } 
   function afterSubmit(retObject,successHint,failHint){  if(retObject==null){ alert('retObject==null');return;}  if(successHint==undefined) successHint = "JCDP_alert_OK";  if(failHint==undefined) failHint = "JCDP_alert_FAIL";  if (retObject.returnCode != "0") alert(failHint);  else{  alert(successHint);  refreshData();  newClose();  } } 
 //�����λ���� ����
   function changePost(){
	   alert("dsfdsf");
       var applyTeam = "applyTeam="+getElementByTypeAndName('SELECT','apply_team').value;  
   	var applyPost=jcdpCallService("HumanRequiredSrv","queryApplyPostList",applyTeam);
    	var well_num_control = getElementByTypeAndName('SELECT','post');
   	for(var i=well_num_control.options.length-1;i>0;i--){
   		well_num_control.options.remove(i);
   	}
   	if(applyPost.detailInfo!=null){
   		for(var i=0;i<applyPost.detailInfo.length;i++){
   			var templateMap = applyPost.detailInfo[i];
   			well_num_control.options[well_num_control.options.length]=new Option(templateMap.label,templateMap.value); 
   			if(templateMap.value==defaultPost){
   				well_num_control.selectedIndex = well_num_control.options.length-1;
   			}
   		}
   	}
   }
   </script> 
  
  <title>dialog</title> 
 </head> 
 <body class="bgColor_f3f3f3" onload="page_init(),changePost()"> 
  <div class="tableWrap"> 
   <form name="fileForm" enctype="multipart/form-data" method="post" target="hidden_frame"> 
    <span id="hiddenFields" style="display:none"></span>
    <table id="rtCRUTable" class="table_form" cellpadding="0" cellspacing="0">  
    </table> 
   </form> 
   <iframe name="hidden_frame" width="1" height="1" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"></iframe> 
  </div> 
  <div class="ctrlBtn" id="cruButton"> 
   <input type="button" onclick="newClose()" class="btn btn_close" />
  </div> 
  <script type="text/javascript">
var $parent = top.$;
function setCruTitle(){
	$parent('#dialog').dialog('option','title',cruTitle);
}
function refreshData(){
		var ctt = top.frames('list');
		if(ctt.frames.length == 0){
				ctt.refreshData();
		}
		else{
				ctt.frames[1].refreshData();
		}
}
function newClose(){
		//$parent('#dialog').dialog('close');
		self.parent.$("#dialogin").remove();
		$parent('#dialog').remove();
		//self.parent.$("#dialog").remove();
}	

  </script>   
 </body>
</html>