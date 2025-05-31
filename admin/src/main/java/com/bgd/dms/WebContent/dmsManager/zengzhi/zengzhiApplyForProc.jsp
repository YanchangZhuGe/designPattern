<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String zz_info_id=request.getParameter("zz_info_id");
	if(null==zz_info_id){
		zz_info_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<style type="text/css">
label{
            position: relative;
        }
  		.fileInput{
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
        }
        .btnIput{
            margin-right: 5px;
        }
        .textInput{
            color: red;
        }
</style>
<title>增值基本信息</title>
</head>

<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
     <fieldset style="margin:2px;padding:2px;"><legend>增值基本信息</legend>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	  <tr style="text-align: left">
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;增值内容:</td>
		  <td><input name="valueadd_content" id="valueadd_content" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" readonly="readonly"/></td>		
		  <td class="inquire_item4" width="10%" style="text-align: center;">&nbsp;增值总金额(元):</td>
		  <td><input name="amount_money" id="amount_money" class="input_width easyui-validatebox main" type="text"  data-options="validType:'length[0,50]'" maxlength="50" readonly="readonly"/></td>
	  </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;"><span>&nbsp;附件:</span></td>
		  <td class='inquire_form' id="zengzhi_purchase_td">
		  </td>
	  </tr>
	  </table>
	  
	   <fieldset style="margin:2px;padding:2px;">
	   <h5 align="center"><font size="15px" style="text-align: center; font-size: 15px">单据明细</font></h5>
    	 <table  style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable">
			<tr>
				<td width="10%" class="ali_btn" style="position: center;">
				</td>
				<td width="2%">序号</td>
				<td width="14%">设备名称</td>
				<td width="14%">规格型号</td>
				<td width="14%">ERP设备编号</td>
				<td width="14%">增值金额(元)</td>
				<td width="14%">采购订单号</td>
				<td width="14%">项目编号</td>
			</tr>
		</table>
      </fieldset>
</div>
</div>
</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
 	cruConfig.queryStr = ""; 
	cruConfig.queryService = "ModelApply";
	var flag="<%=flag%>";
	var zz_info_id= "<%=zz_info_id%>";
	$().ready(function(){
		//禁止日期框手动输入
		$("#sgs_date").datebox({
			editable: false
        });
	});
	function RepNumber(obj) {
        var reg = /^[\d]+$/g;
         if (!reg.test(obj.value)) {
             var txt = obj.value;
             txt.replace(/[^0-9]+/, function (char, index, val) {//匹配第一次非数字字符
                obj.value = val.replace(/\D/g, "");//将非数字字符替换成""
                var rtextRange = null;
                if (obj.setSelectionRange) {
                    obj.setSelectionRange(index, index);
                } else {//支持ie
                    rtextRange = obj.createTextRange();
                    rtextRange.moveStart('character', index);
                    rtextRange.collapse(true);
                    rtextRange.select();
                }
            })
         }
     }
	function checkLength(obj,maxlength){
	    if(obj.value.length > maxlength){
	        obj.value = obj.value.substring(0,maxlength);
	    }
	}
	//新增附件
	function excelDataAdd(status){
			insertTrPublic(status);
	}
	
	//新增插入文件
	var fileOrders = 0;
	function insertTrPublic(obj){
			$("#"+obj+"_td").append(
					"</br><label for='"+obj+"__"+fileOrders+"'>"+
						"<input type='button' id='btn' value='选择文件' class='btnIput'><span id='text1' class='textInput'>请上传文件</span>"+
				  		"<input type='file' name='"+obj+"__"+fileOrders+"' id='"+obj+"__"+fileOrders+"' onchange='backName(this)' class='fileInput' style='width:100%;text-align:left'/>"+
					"</label>"
				);

		fileOrders++;
		//"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td>"+
	}
	function backName(obj){
	       $(obj).prev().html(document.getElementById($(obj).attr("id")).files[0].name);
	}
	$(function(){
			var retObj = jcdpCallService("EquipmentSelectionApply", "getTransferAddedInfo", "zz_id="+zz_info_id);
			if(typeof retObj.str!="undefined"){
				var data = retObj.str;
				$("#valueadd_content").val(data.valueadd_content);
				$("#amount_money").val(data.amount_money);
			}
			if(typeof retObj.fdataPublic!="undefined"){
				// 有附件显示附件
				for (var i = 0; i<retObj.fdataPublic.length; i++) {
						$("#zengzhi_purchase_td").append("<a href='javascript:void(0)' value='"+retObj.fdataPublic[i].file_id+"'  onclick='dowloadFile(this)'>"+retObj.fdataPublic[i].file_name+"</a></br>");
				}
			}
			if(typeof retObj.deviceappMap!="undefined"){
				var datas = retObj.deviceappMap;
				for(var i=0;i<datas.length;i++){
					var ts=insertTr("old");
					var data=datas[i];
					$.each(data, function(k, v){
						if(null!=v && ""!=v){
							$("#itemTable #"+k+"_"+ts).val(v);
						}
					});
					//$.parser.parse();
				}
				orader=datas.length;
			}
	});
	//指标项序号
	var order = new Date().getTime();
	var orderss = 0;
	var orders = 0;
	//添加指标项行
	function insertTr(old){
		orderss++;
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr1_"+orderss+"' class='old' tempindex='"+orderss+"'>";
		}else{
			temp +="<tr id='tr1_"+orderss+"' class='new' tempindex='"+orderss+"'>";
		}
		temp =temp + ("<td><input name='zz_detail_id_"+order+"' id='zz_detail_id_"+order+"' value='000' type='hidden'/></td>" +
		"<td>"+orderss+"</td> "+
		"<td><input name='dev_name_"+order+"' id='dev_name_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,10]'\" size='10' maxlength='10' readonly='readonly'/></td>"+
		"<td><input name='typbz_"+order+"' id='typbz_"+order+"' type='text' style='height:20px;width:90%;' type='text' value='' class='input easyui-validatebox main'  data-options=\"validType:'length[0,10]'\"  size='10' maxlength='10' readonly='readonly'/></td>"+
		"<td><input name='dev_coding_"+order+"' id='dev_coding_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30' readonly='readonly'/></td>"+
		"<td><input name='valueadd_money_"+order+"' id='valueadd_money_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30' readonly='readonly'/></td>"+
		"<td><input name='cg_order_num_"+order+"' id='cg_order_num_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30' readonly='readonly' /></td>"+
		"<td><input name='zzzjitem_"+order+"' id='zzzjitem_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30' readonly='readonly'/></td>"+
		"</tr>");
		$("#itemTable").append(temp);
		return order++; 
	}
	function dowloadFile(obj){
		if($(obj).val().length!=0){
			 var ids = $(obj).val();
			 window.location = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ids;
		}
		
	}
</script>
</html>

