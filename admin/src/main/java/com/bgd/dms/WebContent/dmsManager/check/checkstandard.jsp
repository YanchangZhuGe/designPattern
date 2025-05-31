<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>设备验收</title>
<style type="text/css">
.bt_info_even,.bt_info_odd{

}
</style>
</head>
<body>
	<!-- 最外层layout -->
	<div class="easyui-layout" data-options="fit:true">
		<div id="center" data-options="region:'center',title:'',split:true">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info">
				<tr>
					<td class="bt_info_even">序号</td>
					<td class="bt_info_odd">验收步骤</td>
					<td class="bt_info_odd">验收要点</td>
				</tr>
				<tr>
					<td class="bt_info_even">1</td>
					<td class="bt_info_odd">开箱前检查</td>
					<td class="bt_info_odd">开箱前依据箱单、运单检查到货件数，名称是否相符，外包装是否有破损，裸装设备要检查外观是否有缺损和腐蚀</td>
				</tr>
				<tr>
					<td class="bt_info_even">2</td>
					<td class="bt_info_odd">开箱清点</td>
					<td class="bt_info_odd">依据装箱单检查，核对设备，附件，随机配件，专业工具及及随机资料等是否相符，是否有受潮、锈蚀等受损迹象，核实到货实物与订货合同是否一致</td>
				</tr>
				<tr>
					<td class="bt_info_even">3</td>
					<td class="bt_info_odd">性能指标测试</td>
					<td class="bt_info_odd">按照合同约定和设备出厂的有关指标、性能等技术参数对设备和附件进行性能指标测试</td>
				</tr>
				<tr>
					<td class="bt_info_even">4</td>
					<td class="bt_info_odd">验证</td>
					<td class="bt_info_odd">验收核对随机证件及相关资料</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>