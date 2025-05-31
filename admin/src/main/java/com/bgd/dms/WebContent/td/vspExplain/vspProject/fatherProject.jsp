<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = df.format(new Date());

	String projectType = "";
	if (request.getParameter("projectType") != null) {
		projectType = request.getParameter("projectType");
	}
	String optionType= request.getParameter("optionType");
	String ws_project_no= request.getParameter("ws_project_no");
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String org_id = user.getOrgId();
	String org_sub_id = user.getOrgSubjectionId();
	String userName=user.getUserName();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新建项目</title>
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
</head>
<body>
	<form name="form1" id="form1" method="post"
		action="<%=contextPath%>/ws/pm/project/test2.srq">
		<div id="new_table_box_content">
			<div id="new_table_box_bg">
				<div id="tab_box" class="tab_box">
					<div id="tab_box_content0" class="tab_box_content">
						<table width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr>
								<td class="inquire_item4"><span class="red_star">*</span>项目名：</td>
								<td class="inquire_form4" id="item0_0">
								<input type="hidden"
									id="ws_project_no" name="ws_project_no" value=""
									class="input_width" /> 
								<input type="text"
									id="project_name" name="project_name" value=""
									class="input_width" /></td>
								<td class="inquire_item4">项目编号：</td>
								<td class="inquire_form4" id="item0_1"><input type="text"
									id="project_id" name="project_id" value="从ERP系统自动获取"
									disabled="disabled" class="input_width" /></td>
							</tr>
							<tr>
								<td class="inquire_item4">项目类型：</td>
								<td class="inquire_form4" id="item0_2"><input type="hidden"
									id="project_type" name="project_type" value="<%=projectType%>"
									class="input_width" /> <select class=select_width
									name="project_type_name" id="project_type_name"
									disabled="disabled">
										<option value='5000100004000000008'>井中地震</option>
								</select></td>
								<td class="inquire_item4"><span class="red_star">*</span>市场范围：</td>
								<td class="inquire_form4" id="item0_4"><input
									id="market_classify" name="market_classify" value="0100500006000000001"
									type="hidden" class="input_width" /> <input
									id="market_classify_name" name="market_classify_name" value="国内"
									type="text" class="input_width" readonly="readonly" />
									&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif"
									style="cursor: hand;" border="0"
									onclick="selectMarketClassify()" /></td>
							</tr>
							<tr>
								
								<td class="inquire_item4">年度：</td>
								<td class="inquire_form4" id="item0_5"><select
									id="project_year" name="project_year" class="select_width">
										<%
											Date date = new Date();
											int years = date.getYear() + 1900 - 10;
											int year = date.getYear() + 1900;
											for (int i = 0; i < 20; i++) {
										%>
										<option value="<%=years%>" <%if (years == year) {%>
											selected="selected" <%}%>>
											<%=years%>
										</option>
										<%
											years++;
											}
										%>
								</select></td>
							</tr>
							 
						</table>
					</div>
				</div>
			</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="save()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
			
		</div>
	</form>
</body>

<script type="text/javascript">
//根据上一页选择对项目类型下拉框赋值
var projectType="<%=projectType%>";
var org_id = "<%=org_id%>";
var   project_no="<%=ws_project_no%>";
	 if(project_no !='null'){
			var querySql = "";
			var queryRet = null;
			var  datas =null;		
			
			querySql = "  select s1.coding_name project_type_name,s2.coding_name market_classify_name ,pt.ws_project_no,pt.project_name,pt.project_id,pt.project_year,pt.project_type,pt.market_classify,pt.option_type,pt.bsflag  from GP_WS_PROJECT  pt   left join comm_coding_sort_detail s1   on pt.project_type = s1.coding_code_id   and s1.bsflag = '0'    left join comm_coding_sort_detail s2    on pt.market_classify = s2.coding_code_id   and s2.bsflag = '0'   where pt.bsflag='0' and pt.option_type='<%=optionType%>' and pt.ws_project_no='<%=ws_project_no%>' ";				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){		 
		         	 document.getElementsByName("ws_project_no")[0].value=datas[0].ws_project_no; 		
					 document.getElementsByName("project_name")[0].value=datas[0].project_name;  
					 document.getElementsByName("market_classify_name")[0].value=datas[0].market_classify_name;  
					 document.getElementsByName("market_classify")[0].value=datas[0].market_classify; 
					 document.getElementsByName("project_year")[0].value=datas[0].project_year;  
				}					
				
	    	}		
		
	}

var sel = document.getElementById("project_type_name").options;
for(var i=0;i<sel.length;i++)
{
    if(projectType==sel[i].value)
    {
       document.getElementById('project_type_name').options[i].selected=true;
    }
}

 
 
function selectMarketClassify(){
	var teamInfo = {
		fkValue:"",
		value:""
	};
	window.showModalDialog('<%=contextPath%>/common/selectCode.jsp?codingSortId=0100500006',teamInfo);
	if(teamInfo.fkValue!=""){
		document.getElementById('market_classify').value = teamInfo.fkValue;
		document.getElementById('market_classify_name').value = teamInfo.value;
	}
}

   
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function cancel() {
		window.close();
	}

	function save() {
		if (!checkForm()) return;

		var rowParams = new Array(); 
			var rowParam = {};		
			var   ws_project_no= document.getElementsByName("ws_project_no")[0].value;
			
			var   project_name= document.getElementsByName("project_name")[0].value;
			var   project_type= document.getElementsByName("project_type")[0].value;
			var   market_classify= document.getElementsByName("market_classify")[0].value;
			var   project_year= document.getElementsByName("project_year")[0].value;
			 
			
			
			 rowParam['project_name'] = encodeURI(encodeURI(project_name));
			 rowParam['project_type'] = encodeURI(encodeURI(project_type));
			 rowParam['market_classify'] = encodeURI(encodeURI(market_classify));
			 rowParam['project_year'] = encodeURI(encodeURI(project_year));
			 rowParam['option_type'] = '<%=optionType%>';
		  
			 if(ws_project_no !=null && ws_project_no !=''){
				    rowParam['ws_project_no'] = ws_project_no; 
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['modifi_date'] = '<%=curDate%>';		 
					rowParam['bsflag'] = '0';
					
			  }else{
				    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
					rowParam['create_date'] ='<%=curDate%>';
					rowParam['modifi_date'] = '<%=curDate%>';	
					rowParam['org_id'] = '<%=org_id%>';	
					rowParam['org_sub_id'] = '<%=org_sub_id%>';	
					rowParam['bsflag'] =	'0'; 
				  
			  }  				
		
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	    
				saveFunc("GP_WS_PROJECT",rows);	
				top.frames('list').refreshData();	
				newClose();
	}
   


	function checkForm() {
		var project_name = document.getElementById("project_name").value;
		if(project_name.length==0){
			alert("项目名称不能为空!");
			return;
		}
		
		var market_classify = document.getElementById("market_classify").value;
		if(market_classify.length==0){
			alert("市场范围不能为空!");
			return;
		}
		
		 
		return true;
	}
</script>
</html>