
<%@ page contentType="text/html;charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
 <head> 
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
  <link rel="stylesheet" type="text/css" href="/css/cn/style.css" /> 
  <link href="/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <link rel="stylesheet" type="text/css" href="/styles/style.css" /> 
  <script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="/js/dialog_open.js"></script> 
  <script type="text/javascript" src="/js/table.js"></script> 
  <script type="text/javascript" src="/js/ui/jquery.ui.core.js"></script> 
  <script type="text/javascript" src="/js/ui/jquery.ui.widget.js"></script> 
  <script type="text/javascript" src="/js/ui/jquery.ui.mouse.js"></script> 
  <script type="text/javascript" src="/js/ui/jquery.ui.datepicker.js"></script>
  <script type="text/javascript" src="/js/calendar.js"></script>
  <script type="text/javascript" src="/js/cn/calendar_lan.js"></script>
  <script type="text/javascript" src="/js/calendar-setup.js"></script>
  <script type="text/javascript" src="/js/rt/rt_base.js"></script>
  <script type="text/javascript" src="/js/rt/rt_cru.js"></script>
  <script type="text/javascript" src="/js/cn/rt_cru_lan.js"></script>
  <script type="text/javascript" src="/js/rt/proc_base.js"></script>
  <script type="text/javascript" src="/js/rt/fujian.js"></script>
  <script type="text/javascript" src="/js/rt/rt_validate.js"></script>
  <script type="text/javascript" src="/js/cn/rt_validate_lan.js"></script>
  <script type="text/javascript" src="/js/rt/rt_add.js"></script>
  <script type="text/javascript" src="/js/json.js"></script>
<script type="text/javascript">
	var cruTitle = "添加--仪器租赁费管理";
	var mataxiType = new Array([ '1', '仪器' ], [ '2', '运载设备' ], [ '3', '专用工具' ]);
	var jcdp_codes_items = null;
	var jcdp_codes = new Array();
	var jcdp_record = null;
	/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly， 3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)， MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)， 4最大输入长度， 5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间， 其他默认值 6输入框的长度，7下拉框、自动编码的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加* 9 Column Name，10 Event,11 Table Name*/
	var fields = new Array([ 'JCDP_TABLE_NAME', null, 'Hide', 'TEXT', null,
			'bgp_op_target_device_mataxi' ], [ 'target_mataxi_id', 'id',
			'Hide', 'TEXT', , , , , , , ], [ 'if_change', 'bsflag', 'Hide',
			'TEXT', , '0', , , , , ], [ 'bsflag', 'bsflag', 'Hide', 'TEXT', ,
			'0', , , , , ], [ 'project_info_no', 'id', 'Hide', 'TEXT', ,
			'null', , , , , ], [ 'dev_name', '名称', 'Edit', 'TEXT', '32', , , ,
			, , ], [ 'dev_model', '型号', 'Edit', 'TEXT', '32', , , , , , ], [
			'mataxi_type', '类型', 'Edit', 'SEL_OPs', , , , mataxiType, , , ], [
			'dev_count', '数量', 'Edit', 'TEXT', '12', , , , , , ], [
			'plan_start_date', '到达工区验收合格时间', 'Edit', 'D', , , , , , , ], [
			'plan_end_date', '设备撤回存放地时间', 'Edit', 'D', , , , , , , ], [
			'taxi_unit', '租赁单价(元)', 'Edit', 'TEXT', '12', , , , , , ], [
			'taxi_ratio', '管理费利率(若没有则填写0)', 'Edit', 'TEXT', '12', , , , , , ]);
	var uniqueFields = ':';
	var fileFields = ':';
	function submitFunc() {
		var path = cruConfig.contextPath + cruConfig.addOrUpdateAction;
		submitStr = getSubmitStr();
		if (submitStr == null)
			return;
		var retObject = syncRequest('Post', path, submitStr);
		top.frames('list').refreshData();
		afterSubmit(retObject);
	}
	function afterSubmit(retObject, successHint, failHint) {
		if (successHint == undefined)
			successHint = '提交成功';
		if (failHint == undefined)
			failHint = '提交失败';
		if (retObject.returnCode != "0")
			alert(failHint);
		else {
			alert(successHint);
			newClose();
		}
	}
	function page_init() {
		setCruTitle();
		cruConfig.contextPath = "";
		cruConfig.querySql = "select * from bgp_op_target_device_mataxi where bsflag='0' and if_change = '0' and mataxi_type !='4' and target_mataxi_id = 'null'";
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
