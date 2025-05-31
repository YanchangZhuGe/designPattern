<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@include file="/common/include/quotesresource.jsp"%>
	<title>设备现状分析</title>
</head>

<body style="background:#cdddef">
	<div class="tongyong_box" id="title_div">
		<div class="tongyong_box_title">
			<span>物探处：</span>
			<select id="org_sub_id_1" name="org_sub_id" class="tongyong_box_title_select">
				<%
					if("C105".equals(orgId)){
				%>
					<option value="">全部</option>
				<%
					}
					if("C105".equals(orgId)){
						for(int i=0;i<DevUtil.orgNameList.size();i++){
							String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
				%>
							<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
				<%
						}
					}else{
						for(int i=0;i<DevUtil.orgNameList.size();i++){
							if(DevUtil.orgNameList.get(i).indexOf(orgId)>=0){
								String[] tmpstrs = DevUtil.orgNameList.get(i).split("-");
				%>
					<option value="<%=tmpstrs[0]%>"><%=tmpstrs[1]%></option>
				<%
							}
						}
					}
				%>
	    	</select>
    		<span>&nbsp;</span>
    		<input type="button" value="查询" class="tongyong_box_title_button" onclick="toQuery()"/>
    		<span>&nbsp;</span>
    		<input type="button" value="清除" class="tongyong_box_title_button" onclick="toClear()"/>
		</div>
	</div>
	<table id="treegrid"  class="easyui-treegrid" style="width:100%;"
		data-options="
		url: '<%=contextPath%>/dms/plan/struAnal/getDevStruInfoData.srq',
		method: 'get',
		rownumbers: true,
		idField: 'id',
		treeField: 'name'">
		<thead>
			<tr>
				<th field="name" width="220">Name</th>
				<th field="orderid" width="100" align="right">orderId</th>
			</tr>
		</thead>
	</table>
</body>
<script type="text/javascript">
	//获取当前年度
	var cDate = new Date();
	var cYear = cDate.getFullYear();
	//var threeYear=
	$(function(){
		$(window).resize(function(){
			$('#treegrid').treegrid('resize',{
				height:$(this).height()-$('#title_div').height()-10
			});
		});
		$('#treegrid').treegrid({
			onBeforeLoad:function(row,param){
				if(row){
					$(this).treegrid('options').url='<%=contextPath%>/dms/plan/struAnal/getDevStruCNodeInfoData.srq';
				}
			},
			height:$(this).height()-$('#title_div').height()-10,
			columns:[
				[{
					field: 'name',
		        	title: '设备类别',
		        	rowspan:2,
		        	align: 'left',
		        	halign: 'center',
		            width: $(this).width() * 0.24
				},{
			        title: '合计',
			        colspan:3
				},{
			        title: '3年内',
			        colspan:3
				},{
			        title: '4-6年',
			        colspan:3
				},{
			        title: '7-9年',
			        colspan:3
				},{
			        title: '10年以上',
			        colspan:3
				}],[{
					field: 'total_num',
		        	title: '数量',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'total_ori',
		        	title: '原值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'total_net',
		        	title: '净值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'three_num',
		        	title: '数量',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'three_ori',
		        	title: '原值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'three_net',
		        	title: '净值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'four_six_num',
		        	title: '数量',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'four_six_ori',
		        	title: '原值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'four_six_net',
		        	title: '净值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'seven_nine_num',
		        	title: '数量',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'seven_nine_ori',
		        	title: '原值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'seven_nine_net',
		        	title: '净值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'ten_num',
		        	title: '数量',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'ten_ori',
		        	title: '原值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				},{
					field: 'ten_net',
		        	title: '净值(万元)',
		        	align: 'left',
		        	halign: 'center',
		            width: 100
				}]
			]
		});
	});
	// 按照查询条件过滤数据
	function toQuery(){
		$('#treegrid').treegrid('options').url= '<%=contextPath%>/dms/plan/struAnal/getDevStruInfoData.srq';
		$('#treegrid').treegrid({
			queryParams: {
				orgSubId: $('#org_sub_id_1').val()
			}
		}).load();
	}
	// 清除数据
	function toClear(){
		$('#org_sub_id_1').val("");
		$('#treegrid').treegrid('options').url= '<%=contextPath%>/dms/plan/struAnal/getDevStruInfoData.srq';
		$('#treegrid').treegrid({
			queryParams: {
				
			}
		}).load();
	}
</script>
</html>

