<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String devicename = new String(request.getParameter("devicename").getBytes("iso-8859-1"),"gbk");
	String devicemodel = new String(request.getParameter("devicemodel").getBytes("iso-8859-1"),"gbk");
	String isdevicecode = request.getParameter("isdevicecode");
	String dev_ci_code = request.getParameter("dev_ci_code");
	String out_org_id = request.getParameter("out_org_id");
	String out_org_name = new String(request.getParameter("out_org_name").getBytes("iso-8859-1"),"gbk");
	String devicemixinfoid = request.getParameter("devicemixinfoid")==null?"":request.getParameter("devicemixinfoid");
	String apply_num = request.getParameter("apply_num");
	String mixnum = request.getParameter("mixnum");
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>(自有设备)调配单添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend >调配申请信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
			<td class="inquire_item4">申请设备名称</td>
		    <td class="inquire_form4">
		    	<input id="s_dev_name" name="s_dev_name" type="text" value="<%=devicename%>" class="input_width" readonly/>
		    </td>
		    <td class="inquire_item4">申请规格型号</td>
		    <td class="inquire_form4">
		    	<input id="s_dev_model" name="s_dev_model" type="text" value="<%=devicemodel%>" class="input_width" readonly/>
		    	<input id="s_dev_ci_code" name="s_dev_ci_code" type="hidden" value="<%=dev_ci_code%>" readonly/>
		    </td>
        </tr>
        <tr>
          	<td class="inquire_item4">申请数量</td>
		    <td class="inquire_form4">
		    	<input id="m_apply_num" name="m_apply_num" value="<%=apply_num%>" type="text" class="input_width" readonly/>
		    </td>
		    <td class="inquire_item4">调配数量</td>
		    <td class="inquire_form4">
		    	<input id="m_mix_num" name="m_mix_num" value="<%=mixnum%>" type="text" class="input_width" readonly/>
		    </td>
        </tr>
      </table>
      </fieldset>
	  <fieldset style="margin-left:2px"><legend>批量调配明细</legend>
		  <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
			<td class="inquire_item4">调配设备名称</td>
		    <td class="inquire_form4">
		    	<input id="m_dev_name" name="s_dev_name" type="text" class="input_width" />
		    </td>
		    <td class="inquire_item4">调配规格型号</td>
		    <td class="inquire_form4">
		    	<input id="m_dev_model" name="s_dev_model" type="text" class="input_width" />
		    	<input id="m_dev_ci_code" name="m_dev_ci_code" type="hidden" value="<%=dev_ci_code%>" />
		    </td>
        </tr>
        <tr>
        	<td class="inquire_item4">转出单位</td>
		    <td class="inquire_form4">
		    	<input id="s_out_org_name" name="s_out_org_name" type="text" value="<%=out_org_name%>" class="input_width" />
		    	<input id="s_out_org_id" name="s_out_org_id" type="hidden" value="<%=out_org_id%>" class="input_width" />
		    </td>
		    <td class="inquire_item4">闲置数量</td>
		    <td class="inquire_form4">
		    	<input id="m_xianzhi_num" name="m_xianzhi_num" type="text" class="input_width" />
		    </td>
        </tr>
        <tr>
        	<td class="inquire_item4">批量回填数量</td>
		    <td class="inquire_form4">
		    	<input id="m_huitian_num" name="m_huitian_num" type="text" value="<%=mixnum%>" class="input_width" />
		    </td>
		    <td class="inquire_item4"></td>
		    <td class="inquire_form4">
		    	
		    </td>
        </tr>
      </table>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function refreshData(){
		var dev_ci_code = '<%=dev_ci_code%>'
		var out_org_id ='<%=out_org_id%>';
		if('<%=isdevicecode%>'=='N'){
			$("#m_dev_name").val('<%=devicename%>');
			$("#m_dev_model").val('<%=devicemodel%>');
			$("#m_dev_ci_code").val(dev_ci_code);
			
			var str = "select count(1) as m_xianzhi_num from gms_device_account account ";
			str += "where account.dev_type='"+dev_ci_code+"' and using_stat='0110000007000000002' and (search_id is null ";
			if('<%=devicemixinfoid%>'!=''){
				str += "or search_id='<%=devicemixinfoid%>' ";
			}
			str += ") ";
			//如果传进来的转出单位不为空，那么根据所属单位进行过滤 , 下属单位的也可以分配 需要修改
			if(out_org_id!=''&&out_org_id!='null'){
				str += "and owning_org_id='"+out_org_id+"' ";
			}
			alert(str)
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = proqueryRet.datas;
			if(retObj!=undefined){
				$("#m_xianzhi_num").val(retObj[0].m_xianzhi_num);
			}
		}else{
			var innerhtml = "<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick=showCICodePage('"+dev_ci_code+"') />";
			$("#m_dev_name").after(innerhtml);
		}
	}
	function showCICodePage(dev_ci_code){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDevCodeInfoForMix.jsp?dev_ci_code="+dev_ci_code, obj ,"dialogWidth=800px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			//类别id + 设备编码 + 设备名称 + 规格型号
			var returnvalues = vReturnValue.split('~');
			$("#m_dev_ci_code").val(returnvalues[1]);
			$("#m_dev_name").val(returnvalues[2]);
			$("#m_dev_model").val(returnvalues[3]);
			var out_org_id = $("#s_out_org_id").val();
			//查询闲置数量
			var str = "select count(1) as m_xianzhi_num from gms_device_account account ";
			str += "where account.dev_type='"+returnvalues[1]+"' and using_stat='0110000007000000002' and (search_id is null ";
			if('<%=devicemixinfoid%>'!=''){
				str += "or search_id='<%=devicemixinfoid%>' ";
			}
			str += ") ";
			//如果传进来的转出单位不为空，那么根据所属单位进行过滤 , 下属单位的也可以分配 需要修改
			if(out_org_id!=''&&out_org_id!='null'){
				str += "and owning_org_id='"+out_org_id+"' ";
			}
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			retObj = proqueryRet.datas;
			if(retObj!=undefined){
				$("#m_xianzhi_num").val(retObj[0].m_xianzhi_num);
			}
		}
	}
	function submitInfo(){
		var huitian_num = $("#m_huitian_num").val();
		var xianzhi_num  = $("#m_xianzhi_num").val();
		var m_mix_num = $("#m_mix_num").val();
		var s_dev_ci_code = $("#s_dev_ci_code").val();
		var m_dev_ci_code = $("#m_dev_ci_code").val();
		if(xianzhi_num == ''){
			alert("请选择设备型号信息!");
			return;
		}
		if(s_dev_ci_code==m_dev_ci_code){
			if(parseInt(xianzhi_num)<parseInt(m_mix_num)){
				alert("闲置台账数量小于调配数量,请返回父界面修改调配数量!");
				return;
			}else if(parseInt(huitian_num)>parseInt(m_mix_num)){
				alert("回填数量应小于等于调配数量,请修改回填数量!");
				return;
			}
		}else{
			if(parseInt(huitian_num)>parseInt(m_mix_num)){
				alert("回填数量应小于等于调配数量,请修改回填数量!");
				return;
			}
		}
		var s_dev_ci_code = $("#s_dev_ci_code").val();
		var m_dev_ci_code = $("#m_dev_ci_code").val();
		var s_out_org_id = $("#s_out_org_id").val();
		// 转出机构~申请编码~调配编码~调配数量~
		var selectedids = s_out_org_id+"~"+s_dev_ci_code+"~"+m_dev_ci_code+"~"+huitian_num;
		window.returnValue = selectedids;
		window.close();
	}
	function newClose(){
		window.close();
	}
</script>
</html>

