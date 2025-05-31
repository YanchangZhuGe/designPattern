<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId=user.getEmpId();
	String projectInfoNo = null;
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	List<Map> list=OPCommonUtil.getVirtualProjectInfoData(org_subjection_id);
	for(Map map:list){
		if(projectInfoNo==null){
			projectInfoNo=(String)map.get("projectInfoNo");
		}
	}
	boolean audit=OPCommonUtil.getInformationOfAuditVersion(projectInfoNo);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	String new_date = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

  <title>项目费用方案管理</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="5%" class="ali3">项目:</td>
			    <td width="5%" class="ali1">
					 <SELECT id="projectInfoNo" onchange=changeProjectInfoNo()  name=projectInfoNo>
				    	<%for(Map map:list) {
				    	%>
				    		<OPTION value=<%=map.get("projectInfoNo")%>><%=map.get("projectName")%></OPTION>
				    	<%} %>
					</SELECT>
				</td>
			    <td>&nbsp;</td>
		<auth:ListButton css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton>
		
		    <auth:ListButton functionId="OP_TEC_PLAN_EDIT" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
		    <auth:ListButton functionId="OP_TEC_PLAN_EDIT" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
		    <auth:ListButton functionId="OP_TEC_PLAN_EDIT" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
		    <auth:ListButton functionId="OP_TEC_PLAN_EDIT" css="ck" event="onclick='toViewMoney()'" title="JCDP_btn_view"></auth:ListButton>
		    <auth:ListButton functionId="OP_TEC_PLAN_EDIT" css="dr" event="onclick='importExcel()'" title="JCDP_btn_import"></auth:ListButton>
		
	    <auth:ListButton functionId="OP_TEC_PLAN_EDIT" css="dc" event="onclick='exportExcel()'" title="JCDP_btn_export"></auth:ListButton>
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
	      <td class="bt_info_odd"  exp="<input type='checkbox' name='rdo_entity_id' value='{cost_project_schema_id}' id='rdo_entity_id_{cost_project_schema_id}'   />" >选择</td>
	      <td class="bt_info_even" autoOrder="1">序号</td>
	      <td class="bt_info_odd" exp="{schema_name}">方案名称</td>
	      <td class="bt_info_even" exp="{schema_desc}">方案描述</td>
	      <td class="bt_info_odd" exp="{if_decision_name}">是否最终方案</td>
	      <td class="bt_info_even" exp="{user_name}">创建人</td>
	      <td class="bt_info_odd" exp="{create_date}">创建时间</td>
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
		    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">方案技术指标</a></li>
		    <li id="tag3_1"><a href="#" onclick="getTab3(1)">审批流程</a></li>
		  </ul>
	</div>
	<div id="tab_box" class="tab_box" style="overflow:hidden;">
	    <div id="tab_box_content0" class="tab_box_content">
	    	<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="6"><img src="<%=contextPath%>/images/list_13.png"width="6" height="36" /></td>
						<td background="<%=contextPath%>/images/list_15.png">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr align="right">
									<td>&nbsp;</td>
							<auth:ListButton functionId="OP_TEC_PLAN_EDIT" css="bc" event="onclick='saveSchemaTechInfo()'" title="JCDP_save"></auth:ListButton>
								</tr>
							</table></td>
						<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					</tr>
				</table>
			</div>
			<input name="cost_project_schema_id" id="cost_project_schema_id" class="input_width" value="" type="hidden" /> 
			<input name="spare5" id="spare5" class="input_width" value="" type="hidden" />
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="third">
				<tr>
					<td class="inquire_item8">观测系统类型：</td>
					<td class="inquire_form8"> <input name="tech_001" id="tech_001" class="input_width" value="" type="text"  /></td>
					<td class="inquire_item8">设计线束：</td>
					<td class="inquire_form8"> <input name="tech_002" id="tech_002" value="" class="input_width" type="text"  /> </td>
					<td class="inquire_item8"><font color="red">*</font><input type="radio" name="workload" id="workload1" value="1" checked="checked"/>满覆盖工作量</td>
					<td class="inquire_form8"> <input name="tech_003" id="tech_003" value="" class="input_width" type="text"  /> </td>
					<td class="inquire_item8"><font color="red">*</font><input type="radio" name="workload" id="workload2" value="2"/>实物工作量</td>
					<td class="inquire_form8"> <input name="tech_004" id="tech_004" value="" class="input_width" type="text"  /> </td>
				</tr>
				<tr>
					<td class="inquire_item8">井炮生产炮数：</td>
					<td class="inquire_form8"> <input name="tech_005" id="tech_005" value="" class="input_width" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
					<td class="inquire_item8">震源生产炮数：</td>
					<td class="inquire_form8"> <input name="tech_006" id="tech_006" value="" class="input_width" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
					<td class="inquire_item8">气枪生产炮数：</td>
					<td class="inquire_form8"> <input name="tech_007" id="tech_007" class="input_width" value="" type="text"  onkeyup="setTech008()" onkeydown="javascript:return checkIfNum(event);"/> </td>
					<td class="inquire_item8"><font color="red">*</font>总生产炮数：</td>
					<td class="inquire_form8"> <input name="tech_008" id="tech_008" class="input_width" value="" type="text"  disabled="disabled"/> </td>
				</tr>
				<tr>
					<td class="inquire_item8">微测井：</td>
					<td class="inquire_form8"> <input name="tech_009" id="tech_009" class="input_width" value="" type="text"  /> </td>
					<td class="inquire_item8">小折射：</td>
					<td class="inquire_form8"> <input name="tech_010" id="tech_010" value="" class="input_width" type="text"  /> </td>
					<td class="inquire_item8"><font color="red">*</font>接收道数：</td>
					<td class="inquire_form8"> <input name="tech_011" id="tech_011" value="" class="input_width" type="text"  /> </td>
					<td class="inquire_item8"><font color="red">*</font>检波器串数：</td>
					<td class="inquire_form8"> <input name="tech_012" id="tech_012" value="" class="input_width" type="text"  /> </td>
				</tr>
				<tr>
					<td class="inquire_item8">覆盖次数：</td>
					<td class="inquire_form8"> <input name="tech_013" id="tech_013" class="input_width" value="" type="text"  /> </td>
					<td class="inquire_item8">道间距：</td>
					<td class="inquire_form8"> <input name="tech_014" id="tech_014" value="" class="input_width" type="text"  /> </td>
					<td class="inquire_item8">炮点距：</td>
					<td class="inquire_form8"> <input name="tech_015" id="tech_015" value="" class="input_width" type="text"  /> </td>
					<td class="inquire_item8" id="second1">接收线距：</td>
					<td class="inquire_form8" id="second2"> <input name="tech_016" id="tech_016" value="" class="input_width" type="text"  /> </td>
				</tr>
				<tr id="second3">
					<td class="inquire_item8">炮线距：</td>
					<td class="inquire_form8"> <input name="tech_017" id="tech_017" class="input_width" value="" type="text"  /> </td>
					<td class="inquire_item8">单线道数：</td>
					<td class="inquire_form8"> <input name="tech_018" id="tech_018" class="input_width" value="" type="text"  /> </td>
					<td class="inquire_item8">滚动接收线数：</td>
					<td class="inquire_form8"> <input name="tech_019" id="tech_019" value="" class="input_width" type="text"  /> </td>
					<td class="inquire_item8">面元：</td>
					<td class="inquire_form8"> <input name="tech_020" id="tech_020" value="" class="input_width" type="text"  /> </td>
				</tr>
			</table>
		</div>
	    <div id="tab_box_content1" class="tab_box_content" style="display: none">
	    	<wf:startProcessInfo ></wf:startProcessInfo>
	    </div>
	</div>
</body>

<script type="text/javascript">
	$(document).ready(readyForSetHeight);

	frameSize();
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNo = '<%=projectInfoNo%>';
	//流程提交前配置流程关键信息
	function configProecessInfo(){
		var selectIndex = document.getElementById("projectInfoNo").selectedIndex;
		var project_name = document.getElementById("projectInfoNo").options[selectIndex].text;
		processNecessaryInfo={
				businessTableName:"BGP_OP_COST_PROJECT_SCHEMA",
				businessType:"5110000004100000014",
				businessId:projectInfoNo,
				businessInfo:project_name+"经济技术一体化方案审批",
				applicantDate:"<%=new_date%>"
			};
		processAppendInfo={
				projectInfoNo:projectInfoNo,
				schemaId:''
			};
		//获取当前选择记录
		ids = getSelIds('rdo_entity_id');
		processAppendInfo.schemaId=ids;
		if(ids!=null && ids!=''){
			var id = ids.split(",");
			var sql = "update bgp_op_cost_project_schema t set t.if_workflow='0',t.if_decision ='0' where t.project_info_no ='"+projectInfoNo+"';";
			for(var i =0;i<id.length;i++){
				sql = sql+ "update bgp_op_cost_project_schema t set t.if_workflow='1' where t.cost_project_schema_id ='"+id[i]+"';";
			}
			var retObject=jcdpCallService('QualityItemsSrv','saveQuality','sql='+sql);
		}
	}
	function submitOrNot(){
		ids = getSelIds('rdo_entity_id');
		if(ids==null || ids==''){
			alert("请选择方案!");
			return false;
		}
		return true;
	}
	// 简单查询
	function simpleRefreshData(){
		if (window.event.keyCode == 13) {
			refreshData();
		}
	}
	function refreshData(){
		cruConfig.queryStr = "select pv.*,he.user_name,decode(pv.if_decision,'1','是','否') if_decision_name from  bgp_op_cost_project_schema pv left outer join p_auth_user he on pv.creator = he.user_id  where pv.bsflag='0' and pv.project_info_no='"+projectInfoNo+"' order by pv.create_date asc";
		cruConfig.currentPageUrl = "/op/costMangerVersion/costManagerVersion.jsp";
		queryData(1);
		configProecessInfo();
		loadProcessHistoryInfo();
		submitStr="projectInfoNo="+document.getElementById("projectInfoNo").value;
		var retObject=jcdpCallService('OPCostSrv','getInformationOfAuditVersion',submitStr)
		var audit=retObject.audit;
		if(audit==true || audit=='true'){
			var td = document.getElementsByTagName("td");
			for(var i =0;i<td.length;i++){
				if(td[i].className=='ali_btn' && "zj/xg/sc/dr/bc".indexOf(td[i].childNodes[0].className)!=-1){
					td[i].style.display='none';
				}
			}
		}else{
			var td = document.getElementsByTagName("td");
			for(var i =0;i<td.length;i++){
				if(td[i].className=='ali_btn' && "zj/xg/sc/dr/bc".indexOf(td[i].childNodes[0].className)!=-1){
					td[i].style.display='block';
				}
			}
		}
		var project_info_no = document.getElementById("projectInfoNo").value;
		var querySql = "select project_type from bgp_op_cost_project_basic t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var project_type = "3";
		if(queryRet!=null && queryRet.returnCode=='0'){
			project_type = queryRet.datas[0].project_type;
		}
		if(project_type==null || project_type==''){
			project_type = "3";
		}
		if(project_type=='2'){
			document.getElementById("second1").style.display ='none';
			document.getElementById("second2").style.display ='none';
			document.getElementById("second3").style.display ='none';
		}else{
			document.getElementById("second1").style.display ='block';
			document.getElementById("second2").style.display ='block';
			document.getElementById("second3").style.display ='block';
		}
	}
	projectInfoNo=document.getElementById("projectInfoNo").value;
	SetCookie('costProjectInfoNo',projectInfoNo);
	function toView(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costMangerVersion/costManagerVersionEdit.upmd?pagerAction=edit2View&id='+ids);
	}
	function toAdd(){
		if(isAudit())return ;
		var project_info_no = document.getElementById("projectInfoNo").value;
		var project_type = getProjectType(project_info_no);
		popWindow('<%=contextPath%>/op/costMangerVersion/costManagerVersionEdit.jsp?project_info_no='+project_info_no+"&project_type="+project_type);
	}
	
	function toEdit() {
		if(isAudit())return ;
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		var project_info_no = document.getElementById("projectInfoNo").value;
		var project_type = getProjectType(project_info_no);
		popWindow('<%=contextPath%>/op/costMangerVersion/costManagerVersionEdit.jsp?project_info_no='+project_info_no+'&cost_project_schema_id='+ids+"&project_type="+project_type);
	}
	function getProjectType(project_info_no){
		var sql = "select t.spare1 from bgp_op_cost_project_basic t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
		if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var project_type = retObj.datas[0].spare1 ==null ?"":retObj.datas[0].spare1;
			return project_type;
		}	
	}
	function toDelete(){
		if(isAudit())return ;
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		if (!window.confirm("确认要删除吗?")) {
			return;
		}
		var sql = "update bgp_op_cost_project_schema t set t.bsflag='1' where t.cost_project_schema_id ='"+ids+"'";
		var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
		var params = "deleteSql="+sql;
		params += "&ids="+ids;
		syncRequest('Post',path,params);
		refreshData();
	}

	var schemaInfoOfSet = {
			tech_001:'',
			tech_002:'',
			tech_003:'',
			tech_004:'',
			tech_005:'',
			tech_006:'',
			tech_007:'',
			tech_008:'',
			tech_009:'',
			tech_010:'',
			tech_011:'',
			tech_012:'',
			tech_013:'',
			tech_014:'',
			tech_015:'',
			tech_016:'',
			tech_017:'',
			tech_018:'',
			tech_019:'',
			tech_020:'',
			spare5:''
	};
	
	var schDetDataOfSet={
			cost_schema_detail_id:'',
			work_load:'',
			work_situation:'',
			work_factor:'',
			work_reason:'',
			work_device:'',
			work_person:''
	};
	function loadDataDetail(ids){
		//载入费用详细信息
		var querySql = "select * from bgp_op_cost_project_schema where bsflag ='0' and cost_project_schema_id = '"+ids+"' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas != null&&datas.length>0){
			setOneDataInfo(schemaInfoOfSet,datas[0]);
		}else{
			setOneDataInfo(schemaInfoOfSet,null);
		}
		var spare5 = document.getElementById("spare5").value;
		if(spare5=='2'){
			document.getElementById("workload2").checked =true;
		}else{
			document.getElementById("workload1").checked =true;
		}
		document.getElementById("cost_project_schema_id").value=ids;
	}
	
	function changeProjectInfoNo(){
		projectInfoNo=document.getElementById("projectInfoNo").value;
		SetCookie('costProjectInfoNo',projectInfoNo);
		refreshData();
	}
	
	
	function changeProject(ids){
		projectInfoNo=ids;
		refreshData();
	}

	function saveSchemaTechInfo(){
		var project_info_no=document.getElementById("projectInfoNo").value;
		if(document.getElementById("workload1").checked){
			document.getElementById("spare5").value = 1;
		}else{
			document.getElementById("spare5").value = 2;
		}
		var retObject = saveSingleTableInfoByData(schemaInfoOfSet,'bgp_op_cost_project_schema','cost_project_schema_id','project_info_no='+project_info_no);
		if(retObject!=null && retObject.returnCode =='0'){
			alert("保存成功!");
		}else{
			alert("保存失败!");
		}
	}
	
	
	function toViewMoneyInfo(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costMangerVersion/costMangerVersionMoney.jsp?projectInfoNo='+projectInfoNo+'&costProjectSchemaId='+ids);
	}
	
	function toViewMoney(){
		ids = getSelIds('rdo_entity_id');
		if (ids == '') {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/op/costMangerVersion/costManagerVersionBanlance.jsp?projectInfoNo='+projectInfoNo+'&schemaId='+ids);
	}
	
    //chooseOne()函式，參數為觸發該函式的元素本身
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
    
    function toSerach(){
    	var obj=new Object();
    	window.showModalDialog("<%=contextPath%>/op/costProjectManager/costProjectManagerChoose.jsp",obj,"dialogWidth=800px;dialogHeight=600px");
    	document.getElementById("projectInfoNo").value=obj.value;
    	changeProjectInfoNo();
    }
    
    function isAudit(){
    	submitStr="projectInfoNo="+document.getElementById("projectInfoNo").value;
		var retObject=jcdpCallService('OPCostSrv','getInformationOfAuditVersion',submitStr)
		var audit=retObject.audit;
		if(audit==true||audit=="true"){
			alert("当前项目已提交一体化论证方案审批，无法进行对方案进行调整");
			return true;
		}else{
			return false;
		}
    }
    
    function importExcel(){
    	popWindow("<%=contextPath%>/op/common/ExcelImport.jsp?path=/op/OPCostSrv/importProjectSchema.srq");
    }
    function exportExcel(){
    	var project_info_no = document.getElementById("projectInfoNo").value;
    	var index = document.getElementById("projectInfoNo").selectedIndex;
    	var project_name = document.getElementById("projectInfoNo").options[index].text;
    	var checkbox = document.getElementsByName("rdo_entity_id");
    	var checked = false;
    	for(i=0;i<checkbox.length;i++){
    		if(checkbox[i]!=null && checkbox[i].checked){
    			checked = true;
    			var cost_project_schema_id = checkbox[i].value;
    			project_name = encodeURI(encodeURI(project_name));
            	window.open("<%=contextPath%>/op/OPCostSrv/exportProjectSchema.srq?cost_project_schema_id="+cost_project_schema_id+"&project_name="+project_name);
    		}
    	}
    	if(!checked){
    		alert("请选择一个或几个技术方案!");
    	}
    }
    function setTech008(){
		var tech_005 = document.getElementById("tech_005").value;
		var tech_006 = document.getElementById("tech_006").value;
		var tech_007 = document.getElementById("tech_007").value;
		if(tech_005==null || tech_005==''){
			tech_005 = 0;
		}
		if(tech_006==null || tech_006==''){
			tech_006 = 0;
		}
		if(tech_007==null || tech_007==''){
			tech_007 = 0;
		}
		document.getElementById("tech_008").value = tech_005 -(-tech_006)-(-tech_007);
	}
	/* 输入的是否是数字 */
	function checkIfNum(event){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			return false;
		}
	}
</script>
</html>