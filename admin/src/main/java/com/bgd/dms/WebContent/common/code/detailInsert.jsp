<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String extPath = contextPath + "/js/extjs";
	String codingSortId=request.getParameter("codingSortId");
	UserToken user = OMSMVCUtil.getUserToken(request);
	
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
  var cruTitle = "添加--编码明细";
  var endIf = new Array(['0', '否'], ['1', '是']);
  var jcdp_codes_items = null;
  var jcdp_codes = new Array();
  var jcdp_record = null;
  /**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly， 3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)， MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)， 4最大输入长度， 5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间， 其他默认值 6输入框的长度，7下拉框、自动编码的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加* 9 Column Name，10 Event,11 Table Name*/
  var fields = new Array(['JCDP_TABLE_NAME', null, 'Hide', 'TEXT', null, 'comm_coding_sort_detail'], ['coding_sort_id', '编码分类编号', 'Hide', 'TEXT', , '<%=request.getParameter("codingSortId")%>', , , , , ], ['coding_code_id', '分类明细编号', 'ReadOnly', 'TEXT', , , , , , , ], ['coding_name', '编码明细名称', 'Edit', 'TEXT', '70', , , , 'non-empty', , ], ['coding_show_id', '编码显示序号', 'Edit', 'N', '8', , , , , , ], ['coding_code', '编码代码', 'Hide', 'TEXT', , '0', , , , , ], ['superior_code_id', '上级编码编号', 'Hide', 'TEXT', '32', '<%=request.getParameter("superiorCodeId")%>', , , , , ], ['superior_code_name', '上级编码名称', 'ReadOnly', 'TEXT', , '<%=request.getParameter("superiorCodeName")%>', , , , , ], ['coding_mnemonic_id', '编码助记码', 'Edit', 'TEXT', '32', , , , , , ], ['end_if', '是否末级', 'Edit', 'SEL_OPs', , , , endIf, , , ], ['note', '分类明细备注', 'Edit', 'TEXT', '500', , , , , , ], ['bsflag', '', 'Hide', 'TEXT', , '0', , , , , ], ['create_date', '', 'Hide', 'D', , 'CURRENT_DATE_TIME', , , , , ], ['creator', '', 'Hide', 'TEXT', , '<%=user.getUserName()%>', , , , , ], ['creator_id', '', 'Hide', 'TEXT', , '<%=user.getUserId()%>', , , , , ], ['modifi_date', '', 'Hide', 'D', , 'CURRENT_DATE_TIME', , , , , ]);
  var uniqueFields = ':';
  var fileFields = ':';
  function preSubmitFunc() {
      var path = cruConfig.contextPath + cruConfig.addOrUpdateAction;
      submitStr = getSubmitStr();
   //   alert(submitStr);
      if (submitStr == null) return;
      var retObject = syncRequest('Post', path, submitStr);
      afterSubmit(retObject);
  }
  function submitFunc() {
       var result = jcdpCallService('A7Srv', 'getNewCodingCodeId', 'codingSortId=' + getObj('coding_sort_id').value);
 
      if (result.returnCode != "0") {
          alert("操作失败!");
          return;
      }
      getObj('coding_code_id').value = result.newcodeid;
      getObj('coding_show_id').value = result.coding_show_id;
      var params = "table=comm_coding_sort_detail&key=coding_code_id,coding_code,coding_sort_id,bsflag&value='" + getObj('coding_code_id').value + "','" + getObj('coding_code').value + "','" + getObj('coding_sort_id').value + "','1'";
      var result = jcdpCallService('A7Srv', 'insertPrimaryKey', params);
      if (result.returnCode != "0") {
          alert("操作失败!");
          return;
      }
      preSubmitFunc();  
  }
  function afterSubmit(retObject, successHint, failHint) {
      if (successHint == undefined) successHint = '提交成功';
      if (failHint == undefined) failHint = '提交失败';
      if (retObject.returnCode != "0") alert(failHint);
      else {
          alert(successHint);
          refreshData();
          newClose();
      }
  }
  function page_init() {
      setCruTitle();
      cruConfig.contextPath = "<%=contextPath%>";
      cruConfig.lineRange = '1';
      cruConfig.querySql = "select t.* from comm_coding_sort_detail t where t.bsflag = '0' and t.coding_code_id = '<%=request.getParameter("id")%>'";
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
	top.setDialogTitle(window,cruTitle);
}
function refreshData(){
    parent.frames['indexFrame'].frames['list'][1].refreshData();
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
