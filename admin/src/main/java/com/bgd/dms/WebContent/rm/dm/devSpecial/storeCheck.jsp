<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="java.util.Date"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_acc_id = request.getParameter("dev_acc_id");
	String dev_type=request.getParameter("dev_type");
	String check_id=request.getParameter("check_id");
	String dev_name=request.getParameter("dev_name");
	String dev_num=request.getParameter("dev_num");
	String checkperson=request.getParameter("checkperson");
	if(checkperson==null){
	checkperson=user.getUserName();
	}
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@include file="/common/include/quotesresource.jsp"%>
  <title>检查单</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDet()">
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="">
    <div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
  <div id="new_table_box_bg">
  <div class="easyui-layout" style="width:1300px;height:600px;">

    <div data-options="region:'center'">
       <input id="dev_acc_id" name="dev_acc_id"   value="<%=dev_acc_id%>" type="hidden" />				
	  <input id="check_id" name="check_id"   value="<%=check_id%>" type="hidden" />		
	    <input id="ischeck" name="ischeck"   type="hidden" />					 
	   <input type="hidden" name="count" id="count" value="0"/>
	    <fieldset style="margin:2px:padding:2px;"><legend>基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item8"><font style="color:red">*</font>设备名称:</td>
          <td class="inquire_form8">
              <input id="dev_name" name="dev_name"  class="" type="text" readonly/>
          </td>
          <td class="inquire_item8"><font style="color:red">*</font>出厂/管道编号:</td>
          <td class="inquire_form8">
			   <input id="dev_num" name="dev_num"  class="" type="text" readonly />
		  </td>
		            <td class="inquire_item8"><font style="color:red">*</font>检查人:</td>
          <td class="inquire_form8">
			   <input id="CHECKPERSON" name="CHECKPERSON"  value="" type="text" />
		  </td>
            </tr>
      </table>
      </fieldset>
	  <fieldset><legend>检查项</legend>	 
	  	<!-- 检查项信息 -->
	  	<div id="sfx" class="easyui-accordion" style="width:1230px;">	  	
	  	</div>
	  </fieldset>	
	  <!--<fieldset style="margin:2px:padding:2px;"><legend>验收意见</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item8"><font style="color:red">*</font>验收意见:</td>
          <td class="inquire_form8">
              <textarea id="ADVICE" name="ADVICE"  class="textarea" ></textarea>
          </td>
          <td class="inquire_item8"><font style="color:red">*</font>验收人:</td>
          <td class="inquire_form8">
			   <input id="CHECKPERSON" name="CHECKPERSON"  class="input_width" type="text" />
		  </td>
           <td class="inquire_form8" id="ysimage">
           	   <input id="proof_file_ysimage" name="proof_file_ysimage" type="file" />
           </td>
        </tr>
         <tr style="">
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
      </fieldset>-->
      </div>
      </div>
      </div>
      <div id="oper_div">
     	  <span class="bc_btn"><a id="submitButton" href="####" onclick="submitsCheckInfo('')"></a></span>
          <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
      </div>
    </div>
</form>
</body>
<script type="text/javascript"> 
 	//保存提交
	function submitsCheckInfo(number1){
	  	debugger;
		var i=0;
		var ischeck=number1+":"+'<%=appDate%>';
		 
		if(!$('#proof_file_ysimage').val()){
			//$.messager.alert("提示","请选择验收上传附件！","warning");
			//return ;
		}
		if(!$('#proof_file_zgimage').val()){
			//$.messager.alert("提示","请选择整改上传附件！","warning");
			//return ;
		}
		if(!$('#ADVICE').val()){
			//$.messager.alert("提示","请填写验收意见！","warning");
			//return ;
		}
		if(!$('#CHECKPERSON').val()){
			$.messager.alert("提示","请填写验收人！","warning");
			return ;
		}
		if(!$('#ADVICE_RESULT').val()){
			//$.messager.alert("提示","请填写问题整改情况！","warning");
			//return ;
		}
		if(!$('#BYCHECKPERSON').val()){
		 
			//$.messager.alert("提示","请填写整改验收人！","warning");
			//return ;
		}
			
	 	debugger;
		$('#ischeck').val(ischeck);
		if(confirm("提交后数据不能修改，确认提交？")){
		 	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
		
			//调配数量提交operator_name
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveCheckInfoNew.srq";
			document.getElementById("form1").submit();
		}
	}
	
	var PROJECT_INFO_ID;
	//初始化加载数据
	function loadDataDet(){
		 $('#dev_name').val(decodeURI('<%=dev_name%>'));
		  $('#CHECKPERSON').val(decodeURI('<%=checkperson%>'));
	 	 $('#dev_num').val(decodeURIComponent ('<%=dev_num%>'));
		 loadDataCheckInfo();
		  
	}
	var count=0;
	function loadDataCheckInfo(){
 	var retObj = jcdpCallService("DevCommInfoSrv", "getCheckInfoByDevID", "dev_acc_id=<%=dev_acc_id%>&dev_type=<%=dev_type%>&check_id=<%=check_id%>");
	 if(retObj.check_id){
	 $("#check_id").val(retObj.check_id);
	 }
	 if(retObj.checkinfo){
	   	 debugger;
		 $("#ADVICE").val(retObj.checkinfo[0].advice);
		// $("#CHECKPERSON").val(retObj.checkinfo[0].checkperson);
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
			SeelctHtml=SeelctHtml+"<tr><th>序号</th><th>检查项</th><th>是否存在问题</th><th>发现问题</th><th>问题整改</th><th>验证人</th><th>上传图片</th></tr>";
			 var count1=0;
			 
			 for(var j=0;j<datas.length;j++){
				if(datas[j].father_num==datas[i].number1){
				  
					 
					SeelctHtml=SeelctHtml+"<tr><td>"+(count1+1)+"</td><td class='inquire_form8'>"+datas[j].content+"</td>";
				 
					if(checeks){
						
						if(checeks[count].item_flag=='1'){
							SeelctHtml=SeelctHtml+"<td class='inquire_form8'><input type='radio' name='item_flag"+count+"' value='0'> 合格  <input type='radio' checked   name='item_flag"+count+"' value='1'>不合格</td>";
						}else{
							SeelctHtml=SeelctHtml+"<td class='inquire_form8'><input type='radio' checked   name='item_flag"+count+"' value='0'> 合格  <input type='radio'   name='item_flag"+count+"' value='1'>不合格</td>";
						}
						 SeelctHtml=SeelctHtml+"<Td><textarea rows='3' cols='20' name='question"+count+"'>"+checeks[count].question+"</textarea> </td>";
						 SeelctHtml=SeelctHtml+"<Td><textarea rows='3' cols='20' name='result"+count+"'>"+checeks[count].result+"</textarea></td>";
						 SeelctHtml=SeelctHtml+"<Td><textarea rows='3' cols='20' name='checkmen"+count+"'>"+checeks[count].checkmen+"</textarea></td>";
						  
					}else{
						SeelctHtml=SeelctHtml+"<td class='inquire_form8 '><input type='radio' checked   name='item_flag"+count+"' value='0'> 合格  <input type='radio'   name='item_flag"+count+"' value='1'>不合格</td>";
		 				 SeelctHtml=SeelctHtml+"<Td><textarea rows='3' cols='20' name='question"+count+"'></textarea> </td>";
						 SeelctHtml=SeelctHtml+"<Td><textarea rows='3' cols='20' name='result"+count+"'> </textarea></td>";
						 SeelctHtml=SeelctHtml+"<Td><textarea rows='3' cols='20' name='checkmen"+count+"'></textarea></td>";
					}
					 
					
					if(checeks&&checeks[count].file_id){
						SeelctHtml=SeelctHtml+"<Td><input name=\"file"+count+"\" widht='12px'  type='file' ><img style='width: 60px; height: 80px' src='<%=contextPath%>/doc/downloadDoc.srq?docId="+checeks[count].file_id+"' /></td>";
						SeelctHtml=SeelctHtml+"<input type='hidden' value='"+checeks[count].file_id+"' name='file_id"+count+"'>";
					}else{
					SeelctHtml=SeelctHtml+"<Td><input name=\"file"+count+"\" widht='12px'  type='file' ></td> ";
					}
					//if(count1==0){
				   // if(retObj.checkinfo&&retObj.checkinfo[0].ischeck.indexOf(datas[i].number1)!=-1){
				   //    SeelctHtml=SeelctHtml+"<td   rowspan='"+(datas[i].childnum-1)+"'><span class='bc_btn'><a id='submitButton' href='####' onclick=submitsCheckInfo('"+datas[i].number1+"')></a></span></td>"; 
				   // }else{
				   //    SeelctHtml=SeelctHtml+"<td  rowspan='"+(datas[i].childnum-1)+"' ><span class='bc_btn'><a id='submitButton' href='####' onclick=submitsCheckInfo('"+datas[i].number1+"')></a></span></td>";
				   // }
				    //}
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
 