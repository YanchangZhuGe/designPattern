<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.util.Date"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_acc_id = request.getParameter("dev_acc_id");
	String dev_type=request.getParameter("dev_type");
	String check_id=request.getParameter("check_id");
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@include file="/common/include/quotesresource.jsp"%>
  <title>设备检查单</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDet()">
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="">
<div id="new_table_box_content">
  <div id="new_table_box_bg">
  <div class="easyui-layout" style="width:970px;height:680px;">
  <input type="hidden" name="count" id="count" value="0"/>
    <div data-options="region:'center'">
    <input id="dev_acc_id" name="dev_acc_id" class="easyui-textbox" value="<%=dev_acc_id%>" type="hidden" />	
    <input id="check_id" name="check_id" class="easyui-textbox" value="<%=check_id%>" type="hidden" />					 
    <!--
      <fieldset><legend>设备信息</legend>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">队号</td>
			<td class="inquire_form6">			 
				<input id="dui" name="dui" class="easyui-textbox" style="width:50%;"  type="text" readonly/>
				
			</td>
			<td class="inquire_item6" id="td1">车型</td>
			<td class="inquire_form6">
				<input id="dev_model" style="width:50%;" name="dev_model"   class="easyui-textbox" type="text" readonly/>
				<input id="self_num" name="self_num"  style="display: none;"  class="input_width" type="text" readonly/>
			</td>
		  </tr>
		  <tr>		 			  	
			<td class="inquire_item6" id="td2">车号</td>
			<td class="inquire_form6">
				<input id="license_num" name="license_num"  class="easyui-textbox" style="width:50%;" type="text"   readonly/>
			</td>
			<td class="inquire_item6">验收日期</td>
			<td class="inquire_form6">
				<input name="yssj" id="yssj"   style="width:50%;"  class="easyui-textbox" type="text" readonly />
			</td>		    			
		  </tr>
	  </table>	  
	  </fieldset>	 --!> 
	  <fieldset><legend>检查项</legend>	 
	  	<!-- 检查项信息 -->
	  	<div id="sfx" class="easyui-accordion" style="width:1030px;">	  	
	  	</div>
	  </fieldset>	
	  <fieldset style="margin:2px:padding:2px;"><legend>验收意见</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
         <td class="inquire_item8"><font style="color:red">*</font>检查人:</td>
          <td class="inquire_form8">
			   <input id="CHECKPERSON" name="CHECKPERSON"  class="input_width" type="text" />
		  </td>
          <td class="inquire_item8"><font style="color:red">*</font>检查日期:</td>
          <td class="inquire_form8">
           		<input type="text" name="check_date" id="check_date" value="<%=appDate %>" class="input_width easyui-datebox" style="width:130px" editable="false" required/>
          </td>
         
           <td class="inquire_form8" id="ysimage">
           	   <input id="proof_file_ysimage" name="proof_file_ysimage" type="file" />
           </td>
        </tr>
         <tr style="display:none;">
          <td class="inquire_item8"><font style="color:red">*</font>问题整改情况:</td>
          <td class="inquire_form8">
              <textarea id="ADVICE_RESULT" name="ADVICE_RESULT"  class="textarea" ></textarea>
          </td>
          <td class="inquire_item8"><font style="color:red">*</font>整改验收人:</td>
          <td class="inquire_form8">
				<input id="BYCHECKPERSON" name="BYCHECKPERSON"  class="input_width" type="text" />
		  </td>
            <td class="inquire_form8" id="zgimage">
           <input id="proof_file_zgimage" name="proof_file_zgimage" type="file" />
           </td>
        </tr>
      </table>
      </fieldset>
      </div>
      </div>
      </div>
      <div id="oper_div">
     	  <span class="bc_btn"><a id="submitButton" href="####" onclick="submitInfo()"></a></span>
          <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
      </div>
    </div>
</form>
</body>
<script type="text/javascript"> 
 	//保存提交
	function submitInfo(){
		var flag = true;
		var i=0;
		debugger;
		$(".table1").each(function(){
			$(this).find("tr").each(function(){
			 var reason =$("input[name='kf"+i+"']").val();
			 var text = $(this).children("td:eq(1)").text();
			if(reason==''){
			 $.messager.alert("提示","检查项("+text+")，请填写扣分值","warning");
			 flag=false;
			 return false;
			}
			i++;
		});
		});
		if(!flag){return;}
		
		 
		if(!$('#CHECKPERSON').val()){
			$.messager.alert("提示","请填写检查人！","warning");
			return ;
		}
	 
		if(!$('#check_date').datebox('getValue')){
			$.messager.alert("提示","请填写检查日期！","warning");
			return ;
		}
		if(confirm("提交后数据不能修改，确认提交？")){
		 	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
		
			//调配数量提交operator_name
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveCheckInfo.srq";
			document.getElementById("form1").submit();
		}
	}
	
	var PROJECT_INFO_ID;
	//初始化加载数据
	function loadDataDet(){
		 loadDataCheckInfo();
	}
	var count=0;
	function loadDataCheckInfo(){
	 var retObj = jcdpCallService("DevCommInfoSrv", "getCheckInfoByDevID", "dev_type=<%=dev_type%>&check_id=<%=check_id%>");
 
	 if(retObj.checkinfo){
	   	 debugger;
		 $("#ADVICE").val(retObj.checkinfo[0].advice);
		 $("#CHECKPERSON").val(retObj.checkinfo[0].checkperson);
		 $("#ADVICE_RESULT").val(retObj.checkinfo[0].advice_result);
		 $("#BYCHECKPERSON").val(retObj.checkinfo[0].bycheckperson);
		 //判断有没有上传图片
		 if(retObj.checkinfo[0].file_id){
		 $("#zgimage").append("<td class='inquire_item8'> <img style='width: 60px; height: 80px' src='<%=contextPath%>/doc/downloadDoc.srq?docId="+retObj.checkinfo[0].file_id+"' /></td>");
		 }
		 if(retObj.checkinfo[1]){
		 if(retObj.checkinfo[1].file_id){
		 $("#ysimage").append("<td class='inquire_item8'> <img style='width: 60px; height: 80px' src='<%=contextPath%>/doc/downloadDoc.srq?docId="+retObj.checkinfo[1].file_id+"' /></td>");
	 	 }
	 	 }
	 }
	 if(retObj&&retObj.result){
	 	var datas=retObj.result;
	 	var checeks=retObj.check_detail;
		for(var i=0;i<datas.length;i++){
		if(datas[i].father_num==""){
			var SeelctHtml=" <table class='table1' border=\"2\" bordercolor=\"#a0c6e5\" style=\"border-collapse:collapse;\">";
			 var count1=0;
			 var totals=0;
			 for(var j=0;j<datas.length;j++){
				if(datas[j].father_num==datas[i].number1){
				 
				SeelctHtml=SeelctHtml+"<tr><td>"+(count1+1)+"</td><td>"+datas[j].content+"</td>";
					debugger;
					if(checeks){
						 SeelctHtml=SeelctHtml+"<Td>&nbsp;&nbsp;检查记录<input type='input' value='"+checeks[count].reason+"' name='bz"+count+"'/></td>";
							SeelctHtml=SeelctHtml+"<td>分值："+datas[j].score+"</td>";
							SeelctHtml=SeelctHtml+"<td>扣分：<input type='input' value='"+checeks[count].score+"' name='kf"+count+"'/></td>"; 
							totals=totals+ Number(datas[j].score);
							if(checeks[count].score!=''){
							totals=totals-Number(checeks[count].score);
							}
						  
					}else{
						SeelctHtml=SeelctHtml+"<Td>&nbsp;&nbsp;检查记录<input type='input'   name='bz"+count+"'/></td>";
						SeelctHtml=SeelctHtml+"<td>分值："+datas[j].score+"</td>";
						SeelctHtml=SeelctHtml+"<td>扣分：<input type='input' name='kf"+count+"'/></td>"; 
						totals=totals+ Number(datas[j].score);
					}
					 
				    if(count1==0){
				    SeelctHtml=SeelctHtml+"<td rowspan='"+(datas[i].childnum-1)+"' >得分:@@</td>";
				    }
				   	if(count1+1==datas[i].childnum-1){ SeelctHtml=SeelctHtml.replace("@@",totals);}
					SeelctHtml=SeelctHtml+"</Tr>";
					SeelctHtml=SeelctHtml+"<input type='hidden' value='"+datas[j].item_id+"' name='item_id"+count+"'>";
					SeelctHtml=SeelctHtml+"<input type='hidden' value='"+datas[j].number1+"' name='number1"+count+"'>"; 
				
					count=count+1;
					count1=count1+1;
					}
				}
				SeelctHtml=SeelctHtml+"</table>";
				$('#sfx').accordion('add',{
					title:datas[i].content,
					content:SeelctHtml
				});
				
			
		}
	 }
	$('#count').val(count);//设置一共多少检查项
		var st = $(".panel-title");
				for(var i = 0; i < st.length; i++){
   				var title = st[i].innerHTML;
    			st[i].innerHTML="<span style='color:black'>"+title+"</span>";
    			}
	}
}
	  
</script>
</html>
 