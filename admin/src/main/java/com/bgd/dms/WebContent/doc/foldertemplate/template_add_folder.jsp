<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.ConfigHandler"%>
<%@page import="com.cnpc.jcdp.cfg.ConfigFactory"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
	String folderAbbr = ""; 
	String templateName = "";
	String is_template = "";
	String selectedNodeId = "";
	String pf_id = "";
	
	if(request.getParameter("id") != null){
		folderAbbr = request.getParameter("id");
	}
	if(request.getParameter("pf_id") != null){
		pf_id = request.getParameter("pf_id");
	}
	
	if(request.getParameter("is_template") != null){
		is_template = request.getParameter("is_template");
	}
	if(request.getParameter("selectedNodeId") != null){
		selectedNodeId = request.getParameter("selectedNodeId");
	}
	
	
	String parentFolderText = "";
	if(request.getParameter("parentfoldertext") != null){
		parentFolderText = java.net.URLDecoder.decode(request.getParameter("parentfoldertext"),"UTF-8");
	} 
	if(request.getParameter("templatename") != null){
		templateName = request.getParameter("templatename");
	}
	UserToken user = OMSMVCUtil.getUserToken(request);
	
	String projectNo = user.getProjectInfoNo();
	
	String fileNumberFormat = cfgHd.getSingleNodeValue("//doc/number_format");
	
	String onum = "";
	String sql = "select order_num+50 as onum   from ( Select   nvl(order_num,0)order_num, row_number() over(partition by  PARENT_FILE_ID  order by  create_date   desc ) r   FROM BGP_DOC_GMS_FILE      WHERE PARENT_FILE_ID =    (select g.file_abbr    from bgp_doc_gms_file g  where g.file_id = '"+selectedNodeId+"'  and g.bsflag = '0')  and bsflag = '0'  and project_info_no is null   and　is_template='"+is_template+"'  ) t where t.r='1' ";
	Map map  = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		onum = (String)map.get("onum");
	}else{
		onum = "50";
	}
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
 <head> 
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/styles/style.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
  <script type="text/javascript">
   var cruTitle = "添加--模板增加目录"; 
   var jcdp_codes_items = null; 
   var jcdp_codes = new Array(); 
   var jcdp_record = null; /**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly， 3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)， MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)， 4最大输入长度， 5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间， 其他默认值 6输入框的长度，7下拉框、自动编码的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加* 9 Column Name，10 Event,11 Table Name*/ 
   var fields = new Array(['JCDP_TABLE_NAME',null,'Hide','TEXT',null,'BGP_DOC_GMS_FILE'] ,
		   ['file_id','文档ID','Hide','TEXT',,,,,,,],
		   ['parent_file_id','父目录','Hide','TEXT',,'<%=folderAbbr%>',,,,,],
		   ['parent_folder','上级目录','ReadOnly','TEXT',,'<%=parentFolderText%>',,,,,],
		   ['file_name','目录名称','Edit','TEXT',,,,,'non-empty',,],
		   ['file_abbr','目录缩写','Edit','TEXT',,,,,'non-empty',,],
		   ['order_num','排序编号','ReadOnly','TEXT',,'<%=onum%>',,,'',,],
		   ['ucm_id','文档ucmID','Hide','TEXT',,,,,,,],
		   ['file_type','文件类型','Hide','TEXT',,'',,,,,],
		   ['bsflag','文件状态','Hide','TEXT',,'0',,,,,],
		   ['creator_id','创建人','Hide','TEXT',,'<%=user.getUserId()%>',,'NONE',,,],
		   ['updator_id','修改人','Hide','TEXT',,'<%=user.getUserId()%>',,'NONE',,,],
		   ['create_date','创建时间','Hide','TEXT',,'CURRENT_DATE_TIME',,,,,],
		   ['modifi_date','修改时间','Hide','TEXT',,'CURRENT_DATE_TIME',,,,,],
		   ['is_file','是否文档','Hide','TEXT',,'0',,'NONE',,,],
		   ['is_template','是否模板','Hide','TEXT',,'<%=is_template%>',,'NONE',,,],
		   ['template_name','模板名称','Hide','TEXT',,'<%=templateName%>',,'NONE',,,],
		   ['file_number_format','目录编码规则','Hide','TEXT',,'<%=fileNumberFormat%>',,,,,],
		   ['org_id','org_id','Hide','TEXT',,'<%=user.getCodeAffordOrgID()%>',,,,,],
		   ['org_subjection_id','org_subjection_id','Hide','TEXT',,'<%=user.getSubOrgIDofAffordOrg()%>',,,,,]); 
   var uniqueFields = ':';
   var fileFields = ':'; 
   function afterSubmit(retObject,successHint,failHint){ 
	   if(successHint==undefined) successHint = '提交成功'; 
	   if(failHint==undefined) failHint = '提交失败'; 
	   if (retObject.returnCode != "0") alert(failHint);
	   else{ top.frames['list'].reloadNeed(); newClose(); } 
	   } 
   function preSubmitFunc(){ 
	   var path = cruConfig.contextPath+cruConfig.addOrUpdateAction; 
	   submitStr = getSubmitStr(); 
	   if(submitStr == null) return; 
	   var retObject = syncRequest('Post',path,submitStr); 
	   afterSubmit(retObject); 
	   }  
   function submitFunc(){ 
	   var result = jcdpCallService('ucmSrv','checkFolderAbbr','folderAbbr='+getObj('file_abbr').value+'&is_template=<%=is_template%>&pf_id=<%=pf_id%>'); 
	   if(result.isexist == 1){ alert("该缩写已存在,不能重复!"); return; } 
	   preSubmitFunc(); 
	   }  
   function page_init(){ 
	   setCruTitle();  
	   cruConfig.contextPath = "<%=contextPath%>";  
	   cruConfig.openerUrl = "/doc/foldertemplate/edit_template.jsp";  
	   //cruConfig.querySql = "select f1.* from BGP_DOC_GMS_FILE f1 where f1.file_abbr = 'ml1' and f1.bsflag = '0' and f1.is_template = '1'";  
	   cru_init(); 
	   } 
  </script> 
  <title>dialog</title> 
 </head> 
 <body class="bgColor_f3f3f3" onload="page_init()"> 
  <div id="new_table_box"> 
   <div id="new_table_box_content"> 
    <div id="new_table_box_bg"> 
     <form name="fileForm" enctype="multipart/form-data" method="post" target="hidden_frame"> 
      <span id="hiddenFields" style="display:none"></span>
      <table id="rtCRUTable" class="tab_line_height" cellpadding="0" cellspacing="0">  
      </table> 
     </form> 
     <iframe name="hidden_frame" width="1" height="1" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"></iframe> 
    </div> 
    <div class="ctrlBtn" id="cruButton">
     <input type="button" onclick="submitFunc()" class="btn btn_submit" />
     <input type="button" onclick="newClose()" class="btn btn_close" />
    </div> 
   </div> 
  </div> 
  <script type="text/javascript">
var $parent = top.$;
function setCruTitle(){
	$parent('#dialog').dialog('option','title',cruTitle);
}
function refreshData(){
		var ctt = top.frames['list'];
		if(ctt.frames.length == 0){
				ctt.refreshData();
		}
		else{
				ctt.frames[1].refreshData();
		}
}
$(function(){
	var url = window.location.href;
	if(url.indexOf("&noCloseButton=true")>0){
		$("#cruButton").css("display","none");
		$("#new_table_box_bg").css("height",$(window).height()-55);
	}
});
 
  </script>   
 </body>
</html>

