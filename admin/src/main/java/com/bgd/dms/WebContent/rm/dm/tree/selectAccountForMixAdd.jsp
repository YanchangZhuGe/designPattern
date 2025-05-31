<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	int orgidlength = suborgid.length();
	String dev_name = request.getParameter("dev_name")==null?"":request.getParameter("dev_name");
	String dev_model = request.getParameter("dev_model")==null?"":request.getParameter("dev_model");
	String out_org_id = request.getParameter("out_org_id");
	String devicemixinfoid = request.getParameter("devicemixinfoid")==null?"":request.getParameter("devicemixinfoid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

 <title>为补充出库查询多项目的设备台账</title> 
 </head> 
 
 <body style="background:#F1F2F3;overflow:auto" onload="initpage()">
      	<div id="list_table">
			<div id="inq_tool_box" style="height:64px;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_131.png" width="6" height="64" /></td>
			    <td background="<%=contextPath%>/images/list_151.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备编码</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_type" name="s_dev_type" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_name" name="s_dev_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_model" name="s_dev_model" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			  <tr>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_self_num" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">实物标识号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_sign" name="s_dev_sign" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_license_num" name="s_license_num" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_171.png" width="4" height="64" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id' idinfo='{dev_acc_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_acc_id}' id='selectedbox_{dev_acc_id}'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp={dev_type}>设备编码</td>
					<td class="bt_info_even" exp={dev_name}>设备名称</td>
					<td class="bt_info_odd" exp={dev_model}>规格型号</td>
					<td class="bt_info_even" exp={self_num}>自编号</td>
					<td class="bt_info_odd" exp={dev_sign}>实物标识号</td>
					<td class="bt_info_even" exp={license_num}>牌照号</td>
					<td class="bt_info_odd" exp={asset_coding}>AMIS资产编号</td>
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
		 </div>
	</div>
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var dev_name = decodeURI('<%=dev_name%>');
	var dev_model = decodeURI('<%=dev_model%>');
	var out_org_id='<%=out_org_id%>';
	var length = <%=orgidlength%>;
	
	var obj = window.dialogArguments;
	
	function searchDevData(){
		var v_dev_ci_name = $("#s_dev_name").val();
		var v_dev_ci_model = $("#s_dev_model").val();
		var v_dev_sign = $("#s_dev_sign").val();
		var v_self_num = $("#s_self_num").val();
		var v_license_num = $("#s_license_num").val();
		var v_dev_type = $("#s_dev_type").val();
		refreshData(v_dev_ci_name,v_dev_ci_model,v_dev_sign,v_self_num,v_license_num,v_dev_type);
	}
	function initpage(){
		$("#s_dev_name").val(dev_name);
		$("#s_dev_model").val(dev_model);
		refreshData(dev_name,dev_model);
	}
	function refreshData(v_dev_ci_name,v_dev_ci_model,v_dev_sign,v_self_num,v_license_num,v_dev_type){
		var str = "select tmp1.dev_acc_id,asset_coding,dev_coding,self_num,dev_sign,license_num,dev_name,dev_model,dev_type ";
		str += "from (select account.dev_acc_id,account.asset_coding,account.dev_coding,account.self_num,";
		str += "account.dev_sign,account.license_num,account.dev_name,account.dev_model,account.dev_type ";
		str += "from gms_device_account account where account.bsflag = '0' and saveflag='0' "
		if(obj.pageselectedstr==null){
			str += "and using_stat='0110000007000000002' and account.tech_stat = '0110000006000000001' ";
		}else{
			str += "and using_stat='0110000007000000002' and account.tech_stat = '0110000006000000001' and dev_acc_id not in ("+obj.pageselectedstr+") ";
		}
		//如果传进来的转出单位不为空，那么根据所属单位进行过滤 , 下属单位的也可以分配 需要修改
		if(out_org_id!=''&&out_org_id!='null'){
			//2015.6.15 修改出库逻辑:所属单位为当前单位,所在为空;所在为当前单位都可出库
			//str += "and owning_sub_id like'<%=out_org_id%>%'  ";
			str += "and (owning_sub_id like '<%=out_org_id%>%' and usage_sub_id is null ";
			str += "or usage_sub_id like '<%=out_org_id%>%') ";
		}
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and account.dev_name like '%"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and account.dev_model like '%"+v_dev_ci_model+"%' ";
		}
		if(v_dev_sign!=undefined && v_dev_sign!=''){
			str += "and account.dev_sign like '%"+v_dev_sign+"%' ";
		}
		if(v_self_num!=undefined && v_self_num!=''){
			str += "and account.self_num like '%"+v_self_num+"%' ";
		}
		if(v_license_num!=undefined && v_license_num!=''){
			str += "and account.license_num like '%"+v_license_num+"%' ";
		}
		if(v_dev_type!=undefined && v_dev_type!=''){
			str += "and account.dev_type like '%"+v_dev_type+"%' ";
		}
		str += ")tmp1 ";
		str += " order by dev_type ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	function disableSelectedRec(){
		//补充给已经选中的信息，在本界面中设置为不可选
		var pageselectedstr = obj.pageselectedstr;
		if(pageselectedstr!=null){
			var infos = pageselectedstr.split(',' , -1);
			for(var index=0;index<infos.length;index++){
				var info = infos[index];
				$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+info+"']").attr("disabled","disabled");
			}
		}
	}
	function dbclickRow(shuaId){
		var obj = document.getElementsByName("selectedbox");
		var count = 0;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				count ++;
			}
		}
		if(count != 1){
			alert("请选择一条记录!");
			return;
		}
		var selectedids = null;
		var columnsObj = null;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				selectedids = selectedobj.value;
				columnsObj = selectedobj.parentNode.parentNode.cells;
				break;
			}
		}
		//返回信息是 队级台账id + AMIS资产编号+ 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号  + 设备编码
		selectedids += "~"+columnsObj[8].innerText+"~"+columnsObj[3].innerText+"~"+columnsObj[4].innerText;
		selectedids += "~"+columnsObj[5].innerText+"~"+columnsObj[6].innerText+"~"+columnsObj[7].innerText+"~"+columnsObj[2].innerText;
		window.returnValue = selectedids;
		window.close();
	} 
	function submitInfo(){
		var obj = document.getElementsByName("selectedbox");
		var count = 0;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				count ++;
			}
		}
		if(count != 1){
			alert("请选择一条记录!");
			return;
		}
		var selectedids = null;
		var columnsObj = null;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				selectedids = selectedobj.value;
				columnsObj = selectedobj.parentNode.parentNode.cells;
				break;
			}
		}
		//返回信息是 队级台账id + AMIS资产编号+ 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号  + 设备编码
		selectedids += "~"+columnsObj[8].innerText+"~"+columnsObj[3].innerText+"~"+columnsObj[4].innerText;
		selectedids += "~"+columnsObj[5].innerText+"~"+columnsObj[6].innerText+"~"+columnsObj[7].innerText+"~"+columnsObj[2].innerText;
		window.returnValue = selectedids;
		window.close();
	}
	function newClose(){
		window.close();
	}
	function loadDataDetail(dev_acc_id){
		$("input[type='checkbox'][name='selectedbox']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][id='selectedbox_"+dev_acc_id+"'][disabled!='disabled']").attr("checked","checked");
    }
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i].disabled==flase && obj[i]==cb) obj[i].checked = true; 
            else obj[i].checked = false;
        }
    } 
</script>
</html>