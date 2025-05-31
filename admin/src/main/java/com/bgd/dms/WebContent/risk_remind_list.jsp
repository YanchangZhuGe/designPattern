<%@ page contentType="text/html;charset=UTF-8"%>
<%
	String contextPath = request.getContextPath();	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/panelTableStyle.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>

 <title>提醒</title>
 </head>

 <body style="background:#fff;padding-left: 0px; padding-right: 0px; padding-top: 0px; padding-bottom: 0px; overflow-y : auto; overflow-x:hidden;" onload="refreshData();">
			<div id="tab_box_content0" class="tab_box_content">
				<input type='hidden' id="plan_id" value=''/>
				<table border="0" cellpadding="0" cellspacing="0" id = "taskTable"
					class="tab_line_height" width="100%" style="background: #efefef;">
					<tr style="height:30px;">
				<!-- 		<td class="bt_info_odd" exp="<input type='checkbox' name='task_entity_id' 
						value='' onclick=doCheck(this)/>" >
					    <input type='checkbox' name='task_entity_id' value='' onclick='check()'/></td>
				 -->	    
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">问题标题</td>
						<td class="bt_info_odd">问题类型</td>
						<td class="bt_info_even">问题描述</td>
						<td class="bt_info_odd">问题状态</td>
						<td class="bt_info_even">提出时间</td>
					</tr>
				</table>
				</div>
			<div id="fenye_box"  style="display:none">
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
				      </label></td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
				</table>
			</div>
</body>
	<script type="text/javascript">
		function refreshData(){
			var retObj = jcdpCallService("MatItemSrv", "selEss", "ids=1");
			if(retObj!=null){
				var url=retObj.url;
				var list=retObj.list;
				for(var i=0;i<list.length;i++){
					var title = list[i].questiontitle;
					var  id   = list[i].questionid;
					var typename = list[i].typename;
					var replaystats = list[i].replaystats;
					var subtime = list[i].subtime;
					var desc = list[i].questiondesc;
					var urgency=list[i].urgency;
					if(desc.length>30){
						desc=desc.substring(0,30);
						}

					var autoOrder = document.getElementById("taskTable").rows.length;
					var newTR = document.getElementById("taskTable").insertRow(autoOrder);
					newTR.style.height = "30px";
					var tdClass = 'even';
					if(autoOrder%2==0){
						tdClass = 'odd';
					}
					

			        var td = newTR.insertCell(0);
			        td.innerHTML = i+1;
			        td.className =tdClass+'_even'
			        if(autoOrder%2==0){
						td.style.background = "#e7f2ff";
					}else{
						td.style.background = "#ffffff";
					}


			        td = newTR.insertCell(1);
			        if(urgency==1){
			        	 td.innerHTML = "<img src='images/emegence.gif'/> "+typename;
				        }else{
				         td.innerHTML = typename;
					        }
			        td.className = tdClass+'_odd';
			        if(autoOrder%2==0){
						td.style.background = "#e7f2ff";
					}else{
						td.style.background = "#ffffff";
					}
			        
			        td = newTR.insertCell(2);

			        td.innerHTML = title;
			        td.className =tdClass+'_even'
			        if(autoOrder%2==0){
						td.style.background = "#e7f2ff";
					}else{
						td.style.background = "#ffffff";
					}
					td = newTR.insertCell(3);
					
			        td.innerHTML = desc;
			        td.id=id;
			        td.className = tdClass+'_odd';
			        if(autoOrder%2==0){
						td.style.background = "#e7f2ff";
					}else{
						td.style.background = "#ffffff";
					}
					td.onclick	= function(){
						top.parent.frames["list"].popWindow("<%=contextPath%>/ess.jsp?stats=1&questionid="+this.id+"",'924:700');
						}
					
			        td = newTR.insertCell(4);
					
			        td.innerHTML = replaystats;
			        td.className = tdClass+'_even';
			        if(autoOrder%2==0){
						td.style.background = "#e7f2ff";
					}else{
						td.style.background = "#ffffff";
					}
					td = newTR.insertCell(5);
					
			        td.innerHTML = subtime;
			        td.className = tdClass+'_odd';
			        if(autoOrder%2==0){
						td.style.background = "#e7f2ff";
					}else{
						td.style.background = "#ffffff";
					}
			        
					}
				
			}
		}
	</script>
</html>