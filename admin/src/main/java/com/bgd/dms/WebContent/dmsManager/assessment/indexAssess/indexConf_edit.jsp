<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String indexconf_id=request.getParameter("indexconf_id");
	if(null==indexconf_id){
		indexconf_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/dmsManager/plan/yearPlan/panel.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>指标编辑信息</title>
</head>

<body style="background:#cdddef"  scroll="no">
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/assess/indexAssess/saveOrUpdateIndexConfInfo.srq?flag=<%=flag%>" enctype="multipart/form-data">
		<div id="new_table_box">
			<div id="new_table_box_content">
		    	<div id="new_table_box_bg">
		    		<!-- 配置表ID -->
		    		<input type="hidden" id="indexconf_id" class="main" name="indexconf_id" />
		    		<fieldset style="margin-left:2px">
		    			<legend>指标基本信息</legend>
						<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
							<tr>
						  		<td class="inquire_item6">指标名称：</td>
				    			<td class="inquire_form6">
				    				<input type="text" id="index_name" name="index_name" class="input_width main"/>
				    			</td>
								<td class="inquire_item6">年度：</td>
				    			<td class="inquire_form6">
				    				<input type="text" id="index_year" name="index_year" class="input_width main" readonly="readonly"/>
				    				<img width="20px" height="20px" id="cal_button" style="cursor: hand;" onmouseover="yearSelector('index_year','cal_button');" src="<%=contextPath%>/images/calendar.gif" />
				    			</td>
				        	</tr>
						</table>
					</fieldset>
					<fieldset style="margin-left:2px;height:290px;overflow-y:auto;" >
						<legend>指标项信息</legend>
						<table  style="table-layout:fixed;" width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_info" id="itemTable">
							<tr>
								<td width="10%" class="ali_btn">
									<span class="zj"><a href="javascript:void(0);" onclick="insertTr()" title="添加"></a></span>
								</td>
								<td width="10%">序号</td>
								<td width="80%">指标项名称</td>
							</tr>
						</table>
					</fieldset>	
					<div>
					    <div id="oper_div">
					    	<auth:ListButton functionId="" css="tj_btn" event="onclick='toSubmit()'"></auth:ListButton>
					        <auth:ListButton functionId="" css="gb_btn" event="onclick='toClose()'"></auth:ListButton>        
					    </div>
					</div>
				</div> 
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">
	var contextpath= "<%=contextPath%>";
	//配置表ID
	var indexconf_id= "<%=indexconf_id%>";
	//增加修改标志
	var flag="<%=flag%>";
	$(function(){
		if("update"==flag){
			var retObj = jcdpCallService("IndexAssessSrv", "getIndexConfInfo", "indexconf_id="+indexconf_id);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
				});
			}
			if(typeof retObj.datas!="undefined"){
				var datas = retObj.datas;
				for(var i=0;i<datas.length;i++){
					var ts=insertTr("old");
					var data=datas[i];
					$.each(data, function(k, v){
						if(null!=v && ""!=v){
							$("#itemTable #"+k+"_"+ts).val(v);
						}
					});
				}
			}
		}
	});
	
	//保存
	function toSubmit(){
		var subForm = $("#form");
		subForm.submit();
	}
	//关闭
	function toClose(){
		newClose();
	}
	//指标项序号
	var order = 0;
	//添加指标项行
	function insertTr(old){
		order++;
		var timestamp=new Date().getTime();//获取时间戳
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+order+"' class='old' tempindex='"+timestamp+"'>";
		}else{
			temp +="<tr id='tr_"+order+"' class='new' tempindex='"+timestamp+"'>";
		}
		temp =temp + ("<td><input name='item_id_"+timestamp+"' id='item_id_"+timestamp+"' type='hidden'/><input name='item_order_"+timestamp+"' id='item_order_"+timestamp+"' value='"+order+"' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this)'/></td>" +
		"<td>"+order+"</td> "+
		"<td><input name='item_name_"+timestamp+"' id='item_name_"+timestamp+"' type='text' style='height:20px;width:98%;' /></td>"+
		"</tr>");
		$("#itemTable").append(temp);
		return timestamp; 
	}
	//删除指标项行
	function deleteTr(item){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var itemId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr_"+tts+"' value='"+itemId+"'/>");
		}
		//获取行id
		var temp = $(item).parent().parent().attr("id");
		//删除行
		$(item).parent().parent().remove();
		//序号重新排序
		var _index = parseInt(temp.split("_")[1]);
		for(var j=_index;j<order;j++){
			//给隐藏域序号赋值
			$("#tr_"+(j+1)).children().eq(0).children().eq(1).val(j);
			//给序号赋值
			var order_td = $("#tr_"+(j+1)).children().eq(1);
			order_td.html(j);
			//给tr 属性 赋值
			$("#tr_"+(j+1)).attr("id","tr_"+j);
		}
		//索引减一
		order=order-1;
	}
	//选择年度
	function yearSelector(inputField,tributton){    
	    Calendar.setup({
	        inputField     :    inputField,   // id of the input field
	        ifFormat       :    "%Y",       // format of the input field
	        align          :    "Br",
			button         :    tributton,
	        onUpdate       :    null,
	        weekNumbers    :    false,
			singleClick    :    true,
			step	       :	1
	    });
	}
</script>
</html>