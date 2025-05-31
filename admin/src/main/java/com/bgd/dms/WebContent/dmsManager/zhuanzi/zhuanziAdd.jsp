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
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;采购编号:</td>
		  <td><input name="cg_order_num" id="cg_order_num" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50" required/></td>		
		  <td class="inquire_item4" width="10%" style="text-align: center;">&nbsp;转资台数:</td>
		  <td><input name="zz_num" id="zz_num" class="input_width easyui-validatebox main" type="text"  data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	  </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;转资总金额:</td>
		  <td><input name="zz_money" id="zz_money" class="input_width easyui-validatebox main" type="text" data-options="validType:'length[0,50]'" maxlength="50" required/></td>
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;批次计划:</td>
		  <td><input name="batch_plan" id="batch_plan" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50"/></td>
		  <!-- onkeyup="javascript:RepNumber(this)"  -->
		 </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;供应商名称:</td>
		  <td><input name="lifnr_name" id="lifnr_name" class="input_width easyui-validatebox main" type="text" value="" data-options="validType:'length[0,50]'" maxlength="50"/></td>
	  </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;"><span>&nbsp;采购合同:</span></td>  
		  <td class='inquire_form' id="contract_purchase_td">
		  <label for="contract_purchase__0">
		  	<input type="button" id="btn" value="选择文件" class="btnIput"><span id="text1" class="textInput">请上传文件</span>
		  	<input type='file' name='contract_purchase__0' id='contract_purchase__0' class="fileInput" onchange="backName(this)" style='width:100%;text-align:left'/>
		  	<span class="zj" style="position: absolute;right:-30px;top:-3px;"><a href="javascript:void(0);" onclick="excelDataAdd('contract_purchase')" title="添加附件"></a>
		   </label>
		  </td>
		  	
		  <td class="inquire_item4" style="text-align: center;">&nbsp;设备验收单:</td>
		  <td class='inquire_form' id="contract_device_td">
		  <label for="contract_device__1">
		   <input type="button" id="btn" value="选择文件" class="btnIput"><span id="text2" class="textInput">请上传文件</span>
		   <input type='file' name='contract_device__1' id='contract_device__1' class="fileInput" onchange="backName(this)" style='width:100%;text-align:left'/>
		   <span class="zj" style="position: absolute;right:-30px;top:-3px;"><a href="javascript:void(0);" onclick="excelDataAdd('contract_device')" title="添加附件"></a>
	 	  </label>
	 	  </td>
	  </tr>
	  <tr>
	  	  <td class="inquire_item4" style="text-align: center;">&nbsp;设备固定资产转资申请单:</td>
		  <td class='inquire_form' id="contract_transfer_td">
		  <label for="contract_transfer__2">
		   	<input type="button" id="btn" value="选择文件" class="btnIput"><span id="text3" class="textInput">请上传文件</span>
		  	<input type='file' name='contract_transfer__2' id='contract_transfer__2' class="fileInput" onchange="backName(this)" style='width:100%;text-align:left'/>
		  	<span class="zj" style="position: absolute;right:-30px;top:-3px;"><a href="javascript:void(0);" onclick="excelDataAdd('contract_transfer')" title="添加附件"></a>
		  </label>
		  </td>
		  <td class="inquire_item4" style="text-align: center;">&nbsp;设备转资报销票据整理单:</td>
		  <td class='inquire_form' id="contract_claim_td">
		  <label for="contract_claim__3">
		   	<input type="button" id="btn" value="选择文件" class="btnIput"><span id="text4" class="textInput">请上传文件</span>
		  	<input type='file' name='contract_claim__3' id='contract_claim__3' class="fileInput" onchange="backName(this)" style='width:100%;text-align:left'/>
		  	<span class="zj" style="position: absolute;right:-30px;top:-3px;"><a href="javascript:void(0);" onclick="excelDataAdd('contract_claim')" title="添加附件"></a>
	  	  </label>
	  	  </td>	
	  </tr>
	  </table>
	  
	   <fieldset style="margin:2px;padding:2px;">
	   <h5 align="center"><font size="15px" style="text-align: center; font-size: 15px">单据明细</font></h5>
    	 <table  style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable">
			<tr>
				<td width="10%" class="ali_btn" style="position: center;">
					<span class="zj"><a href="javascript:void(0);" onclick="insertTr()" title="添加"></a></span>
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
       
	  <div id="oper_div" style="text-align: right;">
     	<span class="bc_btn"><a href="####" id="submitButton" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
   	  </div>
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
	//新增附件
	function excelDataAdd(status){
			insertTrPublic(status);
	}
	
	//新增插入文件
	var fileOrders = 4;
	function insertTrPublic(obj){
		$("#"+obj+"_td").prepend(
			"<label for='"+obj+"__"+fileOrders+"'>"+
				"<input type='button' id='btn' value='选择文件' class='btnIput'><span id='text1' class='textInput'>请上传文件</span>"+
		  		"<input type='file' name='"+obj+"__"+fileOrders+"' id='"+obj+"__"+fileOrders+"' onchange='backName(this)' class='fileInput' style='width:100%;text-align:left'/>"+
			"</label></br>"
		);
		
		fileOrders++;
		//"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td>"+
	}
	function backName(obj){
	       $(obj).prev().html(document.getElementById($(obj).attr("id")).files[0].name);
	}
	$(function(){
		if("update"==flag){
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
						$("#contract_purchase_td").append("</br><span class='textInput'>"+retObj.fdataPublic[i].file_name+"<span class='sc'><a href='javascript:void(0);' onclick='deleteFilePublic(this,\""+retObj.fdataPublic[i].file_id+"\")'  title='删除'></a></span></span>");
					}
					if(retObj.fdataPublic[i].file_type =="contract_device"){
						$("#contract_device_td").append("</br><span class='textInput'>"+retObj.fdataPublic[i].file_name+"<span class='sc'><a href='javascript:void(0);' onclick='deleteFilePublic(this,\""+retObj.fdataPublic[i].file_id+"\")'  title='删除'></a></span></span>");
					}
					if(retObj.fdataPublic[i].file_type =="contract_transfer"){
						$("#contract_transfer_td").append("</br><span class='textInput'>"+retObj.fdataPublic[i].file_name+"<span class='sc'><a href='javascript:void(0);' onclick='deleteFilePublic(this,\""+retObj.fdataPublic[i].file_id+"\")'  title='删除'></a></span></span>");
					}
					if(retObj.fdataPublic[i].file_type =="contract_claim"){
						$("#contract_claim_td").append("</br><span class='textInput'>"+retObj.fdataPublic[i].file_name+"<span class='sc'><a href='javascript:void(0);' onclick='deleteFilePublic(this,\""+retObj.fdataPublic[i].file_id+"\")'  title='删除'></a></span></span>");
					}
				}
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
					$.parser.parse();
				}
				orader=datas.length;
			}
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
		temp =temp + ("<td><input name='zzd_id_"+order+"' id='zzd_id_"+order+"' value='000' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this)'/></td>" +
		"<td>"+orderss+"</td> "+
		"<td><input name='eqktx_"+order+"' id='eqktx_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,10]'\" size='10' maxlength='10' required/></td>"+
		"<td><input name='typbz_"+order+"' id='typbz_"+order+"' type='text' style='height:20px;width:90%;' type='text' value='' class='input easyui-validatebox main'  data-options=\"validType:'length[0,10]'\"  size='10' maxlength='10'/></td>"+
		"<td><input name='dev_coding_"+order+"' id='dev_coding_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30'/></td>");
		if("update"!=flag){
		 temp +="<td><input name='inbdt_"+order+"' id='inbdt_"+order+"' value='<%=appDate %>' type='text' style='height:20px;width:90%;' class='input_width easyui-datebox' data-options=\"validType:'length[0,30]'\" maxlength='30' required/></td>";
		}else{
		 temp +="<td><input name='inbdt_"+order+"' id='inbdt_"+order+"' type='text' style='height:20px;width:90%;' class='input_width easyui-datebox' data-options=\"validType:'length[0,30]'\" maxlength='30' required/></td>";
		}
		 temp +=("<td><input name='answt_"+order+"' id='answt_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30' required /></td>"+
		"<td><input name='org_name_"+order+"' id='org_name_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,30]'\" maxlength='30'/></td>"+
		"</tr>");
		
		$("#itemTable").append(temp);
		if(old!="old"){
			$.parser.parse();
		}
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
	//删除文件
	function deleteFilePublic(item,id){
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
				$(item).parent().parent().prev().remove()
				$(item).parent().parent().remove();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			}
        });
	}
	// 保存
	function saveInfo(){
		var zz_num = $.trim($("#zz_num").val());
		if(zz_num.length<=0){
			$.messager.alert("提示","转资台数不能为空!");
			return;
		}	  
		var zz_money = $.trim($("#zz_money").val());
		if(zz_money.length<=0){
			$.messager.alert("提示","转资总金额不能为空!");
			return;
		}	  
		var batch_plan = $.trim($("#batch_plan").val());
		if(batch_plan.length<=0){
			$.messager.alert("提示","批次计划不能为空!");
			return;
		}
		var lifnr_name = $.trim($("#lifnr_name").val());
		if(lifnr_name.length<=0){
			$.messager.alert("提示","供应商名称不能为空!");
			return;
		}
		var cg_order_num = $.trim($("#cg_order_num").val());
		if(cg_order_num.length<=0){
			$.messager.alert("提示","采购单号不能为空!");
			return;
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/transferFundsInfo.srq?flag="+flag+"&zz_id="+zz_id;
    			document.getElementById("form1").submit();
            }
        });
	}
</script>
</html>

