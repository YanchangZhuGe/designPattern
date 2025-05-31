<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String isSingle=request.getParameter("isSingle")==null?"true":request.getParameter("isSingle");
    String businessType = request.getParameter("businessType")==null?"":request.getParameter("businessType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<!--Remark JavaScript定义-->
<script language="javaScript">
var isSingle='<%=isSingle%>';
var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['comm_coding_sort_deatil']
);
var defaultTableName = 'comm_coding_sort_deatil';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
	
cruConfig.contextPath =  "<%=contextPath%>";

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}

function save(){
	if (!checkForm()) return;
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/wt/toSaveKeyPointDoc.srq?businessType=<%=businessType%>&isSingle="+isSingle;
	form.submit();
	newClose();
}

function checkForm(){
	if(null!=document.getElementById("projectName")){
		if (!isTextPropertyNotNull("projectName", "项目名称")) return false;	
	}
	if(""==document.getElementById("pk_0110000061100000015").value){
		if (!isTextPropertyNotNull("0110000061100000015", "基点网平差图")) return false;	
	}
	if (!isLimitB20("writer","拟编人")) return false; 
	if (!isLimitB20("auditor","审核人")) return false;
	if (!isLimitB20("leader","技术负责人")) return false; 
	return true;
}

function page_init(){
	var fileId = '<%=request.getParameter("id")%>';	
	var businessType = '<%=businessType%>';	
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	

	if(fileId!='null'){
		var querySql = " select * from(select b.project_info_no,p.project_name,t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.title,b.written_time,b.writer,b.auditor,b.scale,b.leader from gp_ws_tecnical_basic b left join gp_task_project p on b.project_info_no=p.project_info_no and p.bsflag='0' left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where m.tecnical_id ='"+fileId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){
			document.getElementById("tecnical_id").value = datas[0].tecnical_id;
			document.getElementById("written_time").value = datas[0].written_time;
			document.getElementById("writer").value = datas[0].writer;
			document.getElementById("auditor").value = datas[0].auditor;
			document.getElementById("leader").value = datas[0].leader;
			if(null!=document.getElementById("projectName")){
				document.getElementById("projectName").value = datas[0].project_name;
			}
			document.getElementById("project_info_no").value = datas[0].project_info_no;
			var sel = document.getElementById("scale").options;
			var value = datas[0].scale;
			for(var i=0;i<sel.length;i++)
			{
			    if(value==sel[i].value)
			    {
			       document.getElementById('scale').options[i].selected=true;
			    }
			}
			for(var i=0;i<datas.length;i++){
				if(""!=datas[i].ucm_id){
					var ucmId=datas[i].ucm_id;
					document.getElementById("pk_"+datas[i].doc_file_type).value =ucmId;
					$("#down_"+datas[i].doc_file_type).html("");
					$("#down_"+datas[i].doc_file_type).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+datas[i].file_name+"</a>");
				}
			}
		}
	}else{
		document.getElementById("business_type").value = businessType;
		document.getElementById("file_abbr").value = fileAbbr;
	}		
}

//选择项目
function selectTeam(){

    var result = window.showModalDialog('<%=contextPath%>/rm/em/humanCostPlan/searchProjectList.jsp','');
    if(result!=""){
    	var checkStr = result.split("-");	
	        document.getElementById("project_info_no").value = checkStr[0];
	        document.getElementById("projectName").value = checkStr[1];
    }
}
</script>
</head>
<body onload="page_init();">
	<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
						<div id="tab_box_content0" class="tab_box_content">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
								  <%
							      	if("false".equals(isSingle)){
							      %>
							       <td class="inquire_item4"><span class="red_star">*</span>项目名称：</td>
						           <td class="inquire_form4">
						           <input name="projectName" id="projectName" class="input_width" value="" type="text" readonly="readonly"/>
						           <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>   
						           </td>
							      <%} %>
									<td class="inquire_item4"></td>
									<td class="inquire_form4">
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">拟编人：</td>
									<td class="inquire_form4"><input type="text" id="writer" name="writer" value="" class="input_width" /></td>
									<td class="inquire_item4">绘图日期：</td>
									<td class="inquire_form4">
										<input type="text" id="written_time" name="written_time" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(written_time,tributton1);" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">审核人：</td>
									<td class="inquire_form4"><input type="text" id="auditor" name="auditor" value="" class="input_width" /></td>
									<td class="inquire_item4">技术负责人</td>
									<td class="inquire_form4"><input type="text" id="leader" name="leader" value="" class="input_width" /></td>
								</tr>
								<tr>
									<td class="inquire_item4">比例尺：</td>
									<td class="inquire_form4"><code:codeSelect cssClass="select_width"  name='scale' option="scale"  selectedValue=""  addAll="true" /></td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
								</tr>
								
								
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>基点网平差图：</td>
									<td colspan="2">
										<input type="hidden" id="pk_0110000061100000015" name="pk_0110000061100000015" value=""/>
										<input type="file" name="0110000061100000015" id="0110000061100000015" class="input_width"/>
					    				<div id="down_0110000061100000015"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
								</tr>
							</table>
						</div>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
	</form>
</body>
</html>
