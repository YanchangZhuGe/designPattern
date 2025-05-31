<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String devType = request.getParameter("devType");
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
 <title>查询物资</title> 
 </head> 
 
 <body style="background:#F1F2F3;overflow:auto" onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	
			  	<td class="ali_cdn_name">材料名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_wz_name" name="s_wz_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">材料编号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_wz_id" name="s_wz_id" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td>&nbsp;</td>
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
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{use_info_detail}' id='selectedbox_{use_info_detail}' {selectflag} />" ><input type='checkbox' name='selectedboxall' id='selectedboxall'></td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{teammat_out_id}">计划单号</td>
					<td class="bt_info_even" exp="{wz_name}">材料名称</td>
					<td class="bt_info_odd" exp="{wz_id}">材料编号</td>
					<td class="bt_info_even" exp="{wz_price}">单价</td>
					<td class="bt_info_odd" exp="{use_num}">出库数量</td>
			     </tr>
			    <tbody id="detaillist" name="detaillist" >
			   </tbody>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
				      </label>
				    </td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
				</table>
			</div>
	</div>
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">
//window.gudingbiaotou='true';
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	$("#table_box").css("height",$(window).height()*0.78);
	//setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function searchDevData(){
		var v_wz_name = $("#s_wz_name").val();
		var v_wz_id = $("#s_wz_id").val();
		refreshData(v_wz_name,v_wz_id);
	}

	
	$("#selectedboxall").change(function(){
		var checkinfo = this.checked;
		$("input[type='checkbox'][id^='selectedbox_']").each(function(){
			if(this.disabled == false){
				this.checked = checkinfo;
			}
		});
	});
	var param = window.dialogArguments;
	function refreshData(v_wz_name,v_wz_id){
		var str = "select MAIN.PROCURE_NO AS TEAMMAT_OUT_ID,BASE.WZ_NAME,sub.use_info_detail,SUB.WZ_ID,SUB.APP_NUM AS USE_NUM,base.WZ_PRICE,";
			str += "case when (select count(1) from GMS_MAT_DEVICE_USE_INFO_DETAIL tmp2 ";
	        str += "where tmp2.use_info_detail in ("+param.pageselectedstr+") and tmp2.use_info_detail = sub.use_info_detail ";
	        str += "group by tmp2.use_info_detail)>=1 then 'disabled' else '' end as selectflag ";
			str += "from GMS_MAT_TEAMMAT_OUT MAIN ";
			str += "LEFT JOIN GMS_MAT_DEVICE_USE_INFO_DETAIL SUB ON MAIN.TEAMMAT_OUT_ID=SUB.TEAMMAT_OUT_ID ";
			str += "LEFT JOIN gms_mat_infomation BASE ON SUB.WZ_ID=BASE.WZ_ID ";
			str += "WHERE MAIN.BSFLAG='0' AND SUB.BSFLAG='0' AND BASE.BSFLAG='0' ";
			str += "AND MAIN.DEV_ACC_ID='"+param.dev_acc_id+"' ";
			str += "and sub.dev_use is null ";
		if(v_wz_name!=undefined && v_wz_name!=''){
			str += "and BASE.WZ_NAME like '%"+v_wz_name+"%' ";
		}
		if(v_wz_id!=undefined && v_wz_id!=''){
			str += "and SUB.WZ_ID like '%"+v_wz_id+"%' ";
		}
		str +=" union select t.PROCURE_NO AS TEAMMAT_OUT_ID,i.WZ_NAME,d.out_detail_id as use_info_detail,d.WZ_ID,d.mat_num as use_num,d.actual_price as WZ_PRICE,''selectflag from gms_mat_teammat_out t left join gms_mat_teammat_out_detail d on t.teammat_out_id=d.teammat_out_id and d.bsflag='0' left join gms_mat_infomation i on d.wz_id=i.wz_id and i.bsflag='0' where t.bsflag='0' and t.dev_acc_id='"+param.dev_acc_id+"' and t.use_type='<%=devType%>' and d.out_detail_id not in (select nvl(repdet.material_spec,'0') from bgp_comm_device_repair_info info left join bgp_comm_device_repair_detail repdet on info.repair_info=repdet.repair_info where info.device_account_id='"+param.dev_acc_id+"')"
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	function submitInfo(){
		var obj = document.getElementsByName("selectedbox");
		var count = 0;
		var selectedids = "('";
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				if(index==0){
					selectedids += obj[index].value;
				}
				else{
					selectedids += "','"+obj[index].value;
				}
				count ++;
				
			}
		}
		selectedids +="')"
		if(count == 0){
			alert("请选择记录!");
			return;
		}
		//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号 
		//selectedids += "~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText+"~"+columnsObj[4].innerText;
		window.returnValue = selectedids;
		window.close();
	}
	function newClose(){
		window.close();
	}
	function loadDataDetail(use_info_detail){
// 		$("input[type='checkbox'][name='selectedbox']").removeAttr("checked");
		//选中这一条checkbox
// 		$("#selectedbox_"+use_info_detail).attr("checked","checked");
    }
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }
    } 
</script>
</html>