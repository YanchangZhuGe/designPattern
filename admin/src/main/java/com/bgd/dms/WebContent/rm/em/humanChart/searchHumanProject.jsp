<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());

	String orgAffordId = user.getSubOrgIDofAffordOrg();
	
	String projectInfoNo = "";
	String projectName = "";
		
	if( resultMsg!=null ){
		if(resultMsg.getValue("projectInfoNo") != null ){
			projectInfoNo = resultMsg.getValue("projectInfoNo");
		}
		if(resultMsg.getValue("projectName") != null ){
			projectName = resultMsg.getValue("projectName");
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
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>

<!--Remark JavaScript定义-->
<script language="javaScript">
var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['BGP_COMM_HUMAN_COST_PLAN']
);
var defaultTableName = 'BGP_COMM_HUMAN_COST_PLAN';
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
	

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
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

function simpleSearch(){

	var projectInfoNo = document.getElementById("s_project_info_no").value;	
	var orgAffordId = "<%=orgAffordId%>";
	
	if(projectInfoNo==''){
		alert("请选择项目");
		return;
	}
	
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/rm/em/queryHumanProjectView.srq";
	form.submit();
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

function toView(applyTeam,post,flag){
	var projectInfoNo = document.getElementById("s_project_info_no").value;	
	popWindow('<%=contextPath%>/rm/em/queryHumanProjectList.srq?projectInfoNo='+projectInfoNo+'&applyTeam='+applyTeam+'&post='+post+'&flag='+flag);
}
</script>
</head>
<body onload="page_init();" style="overflow-y:auto">
<form id="CheckForm" action="" method="post" >
<div>
<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="ali_cdn_name" width="20%">项目名称：</td>
    <td  width="20%">
     <input name="s_project_info_no" id="s_project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>
     <input name="s_project_name" id="s_project_name" class="input_width" value="<%=projectName%>" type="text" readonly="readonly"/>   
     <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam()"/>     
    </td>
 	<td class="ali_query" width="20%">
   		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
  	</td>
	<td>&nbsp;</td>
  </tr>
</table>
</td>
    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
  </tr>
</table>
</div>
 
<div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" id="lineTable" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
    	<tr>
  	      <td class="bt_info_odd" width="3%">序号</td>
  	      <td class="bt_info_even" width="10%">班组</td>
  	      <td class="bt_info_odd" width="10%">岗位</td>
          <td class="bt_info_even" width="8%">计划数</td>
          <td class="bt_info_odd" width="8%">申请数</td>		
          <td class="bt_info_even" width="8%">调配数</td>
          <td class="bt_info_odd" width="8%">已接收</td>			
          <td class="bt_info_even" width="8%">已返还</td>           
          <td class="bt_info_odd" width="8%">在项目</td> 
        </tr>
        
        
        
		<%
		if(resultMsg != null){
			List<MsgElement> list = resultMsg.getMsgElements("datas");
			int b=0;
			int b1=0;
			int b2=0;
			int b3=0;
			int b4=0;
			int b5=0;
			
			int a=0;
			int a1=0;
			int a2=0;
			int a3=0;
			int a4=0;
			int a5=0;
			
			if(list != null){
				for(int i=0;i<list.size();i++){				
					MsgElement msg = (MsgElement)list.get(i);
					Map map = msg.toMap();
					Object tt=map.get("plan_number")==""?"0":map.get("plan_number");
					Object tt1=map.get("people_number")==""?"0":map.get("people_number");
					Object tt2=map.get("prepare_number")==""?"0":map.get("prepare_number");
					Object tt3=map.get("accept_num")==""?"0":map.get("accept_num");
					Object tt4=map.get("return_num")==""?"0":map.get("return_num");
					Object tt5=map.get("pro_num")==""?"0":map.get("pro_num");
					 
					  b=Integer.parseInt((String)tt);
					 b1=Integer.parseInt((String)tt1);
					 b2=Integer.parseInt((String)tt2);
					 b3=Integer.parseInt((String)tt3);
					 b4=Integer.parseInt((String)tt4);
					 b5=Integer.parseInt((String)tt5); 
					 
					a=a+b;a1=a1+b1;a2=a2+b2;a3=a3+b3;a4=a4+b4;a5=a5+b5;
				}	
				
		%>
		
		    <tr>				   
		   	<td class="even_odd" colspan="3" >合计：</td> 
		   	<td class="even_even"><%=a%> </td>
		   	<td class="even_odd"> <%=a1%> </td>
		   	<td class="even_even"> <%=a2%> </td>
		   	<td class="even_odd"><%=a3%> </td>
		   	<td class="even_even"><%=a4%></td>
		   	<td class="even_odd"><%=a5%> </td>
		   </tr>		
		    
		<% 
			}		
		
		}%>
		
		
		
       <% if(resultMsg != null){
		List<MsgElement> list = resultMsg.getMsgElements("datas");
		if(list != null){
			for(int i=0;i<list.size();i++){				
				MsgElement msg = (MsgElement)list.get(i);
				Map map = msg.toMap();
				String className = "";
				if (i % 2 == 0) {
					className = "odd_";
				} else {
					className = "even_";
				}
		%>
	 
		
			   <tr>				   
			   	<td class="<%=className%>odd"><%=i+1%></td>
			   	<td class="<%=className%>even"><%=map.get("apply_team_name")==null?"":map.get("apply_team_name")%></td>
			   	<td class="<%=className%>odd"><%=map.get("post_name")==null?"":map.get("post_name")%></td>
			   	<td class="<%=className%>even"><%=map.get("plan_number")==null?"":map.get("plan_number")%></td>
			   	<td class="<%=className%>odd"><%=map.get("people_number")==null?"":map.get("people_number")%></td>
			   	<td class="<%=className%>even"><%=map.get("prepare_number")==null?"":map.get("prepare_number")%></td>
			   	<td class="<%=className%>odd">
			   	<a href="javascript:toView('<%=map.get("apply_team")%>','<%=map.get("post")%>','1')"><%=map.get("accept_num")==null?"":map.get("accept_num")%></a>
			   	</td>
			   	<td class="<%=className%>even">
			   	<a href="javascript:toView('<%=map.get("apply_team")%>','<%=map.get("post")%>','2')"><%=map.get("return_num")==null?"":map.get("return_num")%></a>
			   	</td>
			   	<td class="<%=className%>odd">
			   	<a href="javascript:toView('<%=map.get("apply_team")%>','<%=map.get("post")%>','3')"><%=map.get("pro_num")==null?"":map.get("pro_num")%></a>
			   	</td>
			   </tr>				   				   				   
		<%
			}			
		}		
	}%>
	</table>	
</div> 

</div>
</form>
</body>
</html>
