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
	String zz_id=request.getParameter("zz_id");
	
	if(null==zz_id){
		zz_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<style type="text/css">
</style>
<title>转资基本信息</title>
</head>

<body class="bgColor_f3f3f3" onload="refreshData()">
<form name="form1" id="form1" method="post" action="" enctype="multipart/form-data">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
     <fieldset style="margin:2px;padding:2px;"><legend>转资基本信息</legend>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >
	  <tr style="text-align: left">		
		  <td class="inquire_item4" width="10%" style="text-align: center;">&nbsp;转资台数:</td>
		  <td><input name="zz_num" id="zz_num" class="input_width easyui-validatebox main" type="text" readonly="readonly"/></td>
	 	  <td class="inquire_item4" style="text-align: center;">&nbsp;转资总金额:</td>
		  <td><input name="zz_money" id="zz_money" class="input_width easyui-validatebox main" type="text" readonly="readonly"/></td>
		
	  </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;批次计划:</td>
		  <td><input name="batch_plan" id="batch_plan" class="input_width easyui-validatebox main" type="text" value="" readonly="readonly"/></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;供应商名称:</td>
		  <td><input name="lifnr_name" id="lifnr_name" class="input_width easyui-validatebox main" type="text" value="" readonly="readonly"/></td>
		  <!-- onkeyup="javascript:RepNumber(this)"  -->
		 </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;采购编号:</td>
		  <td><input name="cg_order_num" id="cg_order_num" class="input_width easyui-validatebox main" type="text" value="" readonly="readonly"/></td> 
		  <td class="inquire_item4" style="text-align: center;">&nbsp;创建人:</td>
		  <td><input name="creator" id="creator" class="input_width easyui-validatebox main" type="text" value="" readonly="readonly"/></td>
	  </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;采购合同:</td>
		  <td class='inquire_form' id="contract_purchase_td"></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;设备验收单:</td>
		  <td class='inquire_form' id="contract_device_td"></td>
	  </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;设备固定资产转资申请单:</td>
		  <td class='inquire_form' id="contract_transfer_td"></td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;设备转资报销票据整理单:</td>
		  <td class='inquire_form' id="contract_claim_td"></td>
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
				<td width="14%">投产日期</td>
				<td width="14%">购置金额</td>
				<td width="14%">设备所属单位</td>
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
	var zz_id= "<%=zz_id%>";
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
	
	$(function(){
			var retObj = jcdpCallService("EquipmentSelectionApply", "getTransferFundsInfo", "zz_id="+zz_id);
			if(typeof retObj.str!="undefined"){
				var data = retObj.str;
				$("#zz_num").val(data.zz_num);
				$("#zz_money").val(data.zz_money);
				$("#batch_plan").val(data.batch_plan);
				$("#lifnr_name").val(data.lifnr_name);
				$("#cg_order_num").val(data.cg_order_num);
				$("#creator").val(data.creator);
			}
			if(typeof retObj.fdataPublic!="undefined"){ 
				// 有附件显示附件
				for (var i = 0; i<retObj.fdataPublic.length; i++) {
					if(retObj.fdataPublic[i].file_type =="contract_purchase"){
						$("#contract_purchase_td").append("<a href='javascript:void(0)' value='"+retObj.fdataPublic[i].file_id+"'  onclick='dowloadFile(this)'>"+retObj.fdataPublic[i].file_name+"</a></br>");
					}
					if(retObj.fdataPublic[i].file_type =="contract_device"){
						$("#contract_device_td").append("<a href='javascript:void(0)' value='"+retObj.fdataPublic[i].file_id+"'  onclick='dowloadFile(this)'>"+retObj.fdataPublic[i].file_name+"</a></br>");
					}
					if(retObj.fdataPublic[i].file_type =="contract_transfer"){
						$("#contract_transfer_td").append("<a href='javascript:void(0)' value='"+retObj.fdataPublic[i].file_id+"'  onclick='dowloadFile(this)'>"+retObj.fdataPublic[i].file_name+"</a></br>");
					}
					if(retObj.fdataPublic[i].file_type =="contract_claim"){
						$("#contract_claim_td").append("<a href='javascript:void(0)' value='"+retObj.fdataPublic[i].file_id+"'  onclick='dowloadFile(this)'>"+retObj.fdataPublic[i].file_name+"</a></br>");
					}
				}
				if($("#contract_purchase_td").find("a").length==0){$("#contract_purchase_td").text("未上传文件")};
				if($("#contract_device_td").find("a").length==0){$("#contract_device_td").text("未上传文件")};
				if($("#contract_transfer_td").find("a").length==0){$("#contract_transfer_td").text("未上传文件")};
				if($("#contract_claim_td").find("a").length==0){$("#contract_claim_td").text("未上传文件")};
			}
			if(typeof retObj.deviceappMap!="undefined"){
				var datas = retObj.deviceappMap;
				for(var i=0;i<datas.length;i++){
					var ts=insertTr("old");
					var data=datas[i];
					$.each(data, function(k, v){
						if(null!=v && ""!=v){
							if(k=="inbdt"){
								v=ecahTime(v);
							}
							$("#itemTable #"+k+"_"+ts).val(v);
						}
					});
				}
				orader=datas.length;
			}
	});
	function ecahTime(str){
		str=str.substring(0,4)+"-"+str.substring(4,6)+"-"+str.substring(6,8);
		return str;
	}
	
	
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
		temp =temp + ("<td><input name='zzd_id_"+order+"' id='zzd_id_"+order+"' value='000' type='hidden'/></td>" +
		"<td>"+orderss+"</td> "+
		"<td><input name='eqktx_"+order+"' id='eqktx_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' readonly='readonly'/></td>"+
		"<td><input name='typbz_"+order+"' id='typbz_"+order+"' type='text' style='height:20px;width:90%;' type='text' value='' class='input easyui-validatebox main'  readonly='readonly'/></td>"+
		"<td><input name='dev_coding_"+order+"' id='dev_coding_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' readonly='readonly'/></td>"+
		"<td><input name='inbdt_"+order+"' id='inbdt_"+order+"' type='text' style='height:20px;width:90%;' readonly='readonly'/></td>"+
		"<td><input name='answt_"+order+"' id='answt_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' readonly='readonly'/></td>"+
		"<td><input name='own_org_name_"+order+"' id='own_org_name_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' readonly='readonly'/></td>"+
		"</tr>");
		
		$("#itemTable").append(temp);
		//$.parser.parse();
		return order++; 
	}
	//删除指标项行
	function deleteTr(item){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var itemId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr_"+tts+"' value='"+itemId+"'/>");
		}
		 if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("EquipmentSelectionApply", "deleteUpdateZzDetauled", "zzd_id="+itemId);				
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						alert("删除失败！");
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						//删除行
						//$(item).parent().parent().remove();
						//获取行id
						var temp = $(item).parent().parent().attr("id");
						//删除行
						$(item).parent().parent().remove();
						//序号重新排序
						var _index = parseInt(temp.split("_")[1]);
						for(var j=_index;j<orderss;j++){
							//给隐藏域序号赋值
							$("#tr1_"+(j+1)).children().eq(0).children().eq(1).val(j);
							//给序号赋值
							var order_td = $("#tr1_"+(j+1)).children().eq(1);
							order_td.html(j);
							//给tr 属性 赋值
							$("#tr1_"+(j+1)).attr("id","tr1_"+j);
						}
						//索引减一
						orderss=orderss-1;
						queryData(cruConfig.currentPage);
					}
				}
			} 
		}
		
	}
	// 获取文件信息
	function getFileInfoPublic(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("__")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#keeping_post_"+order).val(docTitle);//文件name
	}
	function dowloadFile(obj){
		if($(obj).val().length!=0){
			 var ids = $(obj).val();
			 window.location = "<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ids;
		}
		
	}
</script>
</html>

