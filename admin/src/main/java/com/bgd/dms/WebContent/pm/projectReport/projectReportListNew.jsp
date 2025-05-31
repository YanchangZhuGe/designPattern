<%@page import="com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider"%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	System.out.print(contextPath);
	
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/css/bgpmcs_table.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
<script language="JavaScript" type="text/JavaScript" src="/BGPMCS/js/bgpmcs/DivHiddenOpen.js"></script>
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/rt_table.css" type="text/css" />
<link rel="stylesheet" href="<%=contextPath%>/css/common.css" type="text/css" />
<link href="<%=contextPath%>/js/extjs/resources/css/ext-all.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>

<title></title>
</head>
<body>

<form id="form1" action="http://10.88.248.16:8091/default.aspx?username=yueyongxia" method="post">
	<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE" value=""/>
	<input type="hidden" name="__EVENTVALIDATION" id="__EVENTVALIDATION" value=""/>
	<input type="hidden" name="DropDownList1" id="DropDownList1" value="" />
	<input type="hidden" name="BtnQuryWeek" value="查询"/>
</form>

<table border="0"  cellspacing="0"  cellpadding="0"  class="form_info"  width="100%" id="queryRetTable">
	<thead>
	<tr class="bt_info">
		<td class="tableHeader"  >序号</td>
		<td class="tableHeader"  >报表名称</td>
		<td class="tableHeader"  >第一期</td>
		<td class="tableHeader" >第二期</td>
		<td class="tableHeader" >第三期</td>
	</tr>
	</thead>
	<tbody>
		<tr class="even">
			<td class="even_odd">1</td>
			<td class="even_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=001">
					地震勘探项目运行动态表(年报,含全年项目)
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">2</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=002">
					地震勘探项目运行动态表(月报,含全年项目)
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">3</td>
			<td class="even_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=003">
					地震勘探项目运行动态表(周报,含全年项目)
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">4</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=005"> 
					地震采集项目准备信息表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">5</td>
			<td class="even_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=006">
					地震采集项目结束信息表
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">6</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=007">
					二维地震勘探生产报表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">7</td>
			<td class="even_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=008">
					三维地震勘探生产报表
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">8</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=009">
					地震勘探生产问题统计表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">9</td>
			<td class="even_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=010">
					二维地震勘探项目施工因素及设备动态报表
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">10</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=011">
					三维四维地震勘探项目施工因素及设备动态报表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">11</td>
			<td class="even_even">
				<a href="<%=contextPath%>/pm/projectReport/run.jsp?reportId=012">
					地震勘探项目“六个计划、部署图、施工设计、试验总结、施工总结、甲方验收书”加载情况统计
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">12</td>
			<td class="odd_even">
				<a href="javascript:viewERPReport(0,2)">
					井中地震中心项目进度动态表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">13</td>
			<td class="even_even">
				<a href="javascript:viewERPReport(1,2)">
					综合物化探市场开发跟踪动态表
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">14</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/pm/projectReport/dispatch.jsp">
					综合物化探价值工作量统计表(按地区)
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="even_odd">15</td>
			<td class="even_even">
				<a href="<%=contextPath%>/pm/projectReport/dispatch_method.jsp">
					综合物化探价值工作量统计表(按方法)
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">16</td>
			<td class="odd_even">
				<a href="javascript:viewERPReport(4,2)">
					综合物化探勘探项目运作动态表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="even">
			<td class="odd_odd">17</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/pm/projectReport/wsReport.jsp">
					井中项目周报
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">18</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/pm/dailyReport/singleProject/wt/wtdaily.jsp">
					物化探生产日报报表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
<!-- 			<tr class="even">
			<td class="even_odd">9</td>
			<td class="even_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pm_dynamic2&noLogin=admin&tokenId=admin">
					二维地震勘探项目施工因素及设备动态报表
				</a>
			</td>
			<td class="even_odd"></td>
			<td class="even_even"></td>
			<td class="even_odd"></td>
		</tr>
		<tr class="odd">
			<td class="odd_odd">10</td>
			<td class="odd_even">
				<a href="<%=contextPath%>/$bireport/dynamic/rpt/showReport?isRefreshCache=true&reportId=pm_dynamic3&noLogin=admin&tokenId=admin">
					三维四维地震勘探项目施工因素及设备动态报表
				</a>
			</td>
			<td class="odd_odd"></td>
			<td class="odd_even"></td>
			<td class="odd_odd"></td>
		</tr>
 -->	
	</tbody>
</table>
</body>
<script type="text/javascript">
	var __VIEWSTATE=new Array(
			 "/wEPDwULLTEwNzUyNjk4NzQPZBYCZg9kFgoCAQ8QDxYCHgtfIURhdGFCb3VuZGdkEBUREumhueebruWcsOWbvuWxleekuiVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6Zeu6aKY57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67nlJ/kuqfnu5/orqHooaglQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCpCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGoKOW5tClDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOWRqOaKpe+8jOWQq+WFqOW5tOmhueebru+8iUNCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGo77yI5pyI5oql77yM5ZCr5YWo5bm06aG555uu77yJP0JHUF/lnLDpnIfli5jmjqLpobnnm67mlr3lt6Xlm6DntKDlj4rorr7lpIfliqjmgIHmiqXooajvvIgyRO+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIM0TvvIklQkdQX+WcsOmch+mHh+mbhumhueebruWHhuWkh+S/oeaBr+ihqCVCR1Bf5Zyw6ZyH6YeH6ZuG6aG555uu57uT5p2f5L+h5oGv6KGoiAFCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu4oCc5YWt5Liq6K6h5YiS44CB6YOo572y5Zu+44CB5pa95bel6K6+6K6h44CB6K+V6aqM5oC757uT44CB5pa95bel5oC757uT44CB55Sy5pa56aqM5pS25Lmm4oCd5Yqg6L295oOF5Ya157uf6K6h6KGoK0JHUF/kupXkuK3lnLDpnIfkuK3lv4Ppobnnm67ov5vluqbliqjmgIHooaguQkdQX+e7vOWQiOeJqeWMluaOouW4guWcuuW8gOWPkei3n+i4quWKqOaAgeihqDZCR1Bf57u85ZCI54mp5YyW5o6i5Lu35YC85bel5L2c6YeP57uf6K6h6KGoKOaMieWcsOWMuik2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInmlrnms5UpLkJHUF/nu7zlkIjnianljJbmjqLli5jmjqLpobnnm67ov5DkvZzliqjmgIHooagVERLpobnnm67lnLDlm77lsZXnpLolQkdQX+WcsOmch+WLmOaOoumhueebrumXrumimOe7n+iuoeihqCVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu55Sf5Lqn57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooagqQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCjlubQpQ0JHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooajvvIjlkajmiqXvvIzlkKvlhajlubTpobnnm67vvIlDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOaciOaKpe+8jOWQq+WFqOW5tOmhueebru+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIMkTvvIk/QkdQX+WcsOmch+WLmOaOoumhueebruaWveW3peWboOe0oOWPiuiuvuWkh+WKqOaAgeaKpeihqO+8iDNE77yJJUJHUF/lnLDpnIfph4fpm4bpobnnm67lh4blpIfkv6Hmga/ooaglQkdQX+WcsOmch+mHh+mbhumhueebrue7k+adn+S/oeaBr+ihqIgBQkdQX+WcsOmch+WLmOaOoumhueebruKAnOWFreS4quiuoeWIkuOAgemDqOe9suWbvuOAgeaWveW3peiuvuiuoeOAgeivlemqjOaAu+e7k+OAgeaWveW3peaAu+e7k+OAgeeUsuaWuemqjOaUtuS5puKAneWKoOi9veaDheWGtee7n+iuoeihqCtCR1Bf5LqV5Lit5Zyw6ZyH5Lit5b+D6aG555uu6L+b5bqm5Yqo5oCB6KGoLkJHUF/nu7zlkIjnianljJbmjqLluILlnLrlvIDlj5Hot5/ouKrliqjmgIHooag2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInlnLDljLopNkJHUF/nu7zlkIjnianljJbmjqLku7flgLzlt6XkvZzph4/nu5/orqHooago5oyJ5pa55rOVKS5CR1Bf57u85ZCI54mp5YyW5o6i5YuY5o6i6aG555uu6L+Q5L2c5Yqo5oCB6KGoFCsDEWdnZ2dnZ2dnZ2dnZ2dnZ2dnFgECDGQCAw8PFgIeB1Zpc2libGVnZGQCBQ8PFgIfAWhkFgQCAQ8QDxYCHwBnZBAVAgQyMDA4BDIwMDkVAgQyMDA4BDIwMDkUKwMCZ2cWAWZkAgMPEA8WAh8AZ2QQFQwBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTIVDAExATIBMwE0ATUBNgE3ATgBOQIxMAIxMQIxMhQrAwxnZ2dnZ2dnZ2dnZ2cWAQIEZAIHDw8WAh8BaGRkAgkPDxYCHwFoZBYCAgEPFgIeBXZhbHVlBQkyMDExLTUtMTZkZHZqfX4Egmr1O8b9EQrdxA69brTd"
			,"/wEPDwULLTEwNzUyNjk4NzQPZBYCZg9kFgoCAQ8QDxYCHgtfIURhdGFCb3VuZGdkEBUREumhueebruWcsOWbvuWxleekuiVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6Zeu6aKY57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67nlJ/kuqfnu5/orqHooaglQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCpCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGoKOW5tClDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOWRqOaKpe+8jOWQq+WFqOW5tOmhueebru+8iUNCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGo77yI5pyI5oql77yM5ZCr5YWo5bm06aG555uu77yJP0JHUF/lnLDpnIfli5jmjqLpobnnm67mlr3lt6Xlm6DntKDlj4rorr7lpIfliqjmgIHmiqXooajvvIgyRO+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIM0TvvIklQkdQX+WcsOmch+mHh+mbhumhueebruWHhuWkh+S/oeaBr+ihqCVCR1Bf5Zyw6ZyH6YeH6ZuG6aG555uu57uT5p2f5L+h5oGv6KGoiAFCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu4oCc5YWt5Liq6K6h5YiS44CB6YOo572y5Zu+44CB5pa95bel6K6+6K6h44CB6K+V6aqM5oC757uT44CB5pa95bel5oC757uT44CB55Sy5pa56aqM5pS25Lmm4oCd5Yqg6L295oOF5Ya157uf6K6h6KGoK0JHUF/kupXkuK3lnLDpnIfkuK3lv4Ppobnnm67ov5vluqbliqjmgIHooaguQkdQX+e7vOWQiOeJqeWMluaOouW4guWcuuW8gOWPkei3n+i4quWKqOaAgeihqDZCR1Bf57u85ZCI54mp5YyW5o6i5Lu35YC85bel5L2c6YeP57uf6K6h6KGoKOaMieWcsOWMuik2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInmlrnms5UpLkJHUF/nu7zlkIjnianljJbmjqLli5jmjqLpobnnm67ov5DkvZzliqjmgIHooagVERLpobnnm67lnLDlm77lsZXnpLolQkdQX+WcsOmch+WLmOaOoumhueebrumXrumimOe7n+iuoeihqCVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu55Sf5Lqn57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooagqQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCjlubQpQ0JHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooajvvIjlkajmiqXvvIzlkKvlhajlubTpobnnm67vvIlDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOaciOaKpe+8jOWQq+WFqOW5tOmhueebru+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIMkTvvIk/QkdQX+WcsOmch+WLmOaOoumhueebruaWveW3peWboOe0oOWPiuiuvuWkh+WKqOaAgeaKpeihqO+8iDNE77yJJUJHUF/lnLDpnIfph4fpm4bpobnnm67lh4blpIfkv6Hmga/ooaglQkdQX+WcsOmch+mHh+mbhumhueebrue7k+adn+S/oeaBr+ihqIgBQkdQX+WcsOmch+WLmOaOoumhueebruKAnOWFreS4quiuoeWIkuOAgemDqOe9suWbvuOAgeaWveW3peiuvuiuoeOAgeivlemqjOaAu+e7k+OAgeaWveW3peaAu+e7k+OAgeeUsuaWuemqjOaUtuS5puKAneWKoOi9veaDheWGtee7n+iuoeihqCtCR1Bf5LqV5Lit5Zyw6ZyH5Lit5b+D6aG555uu6L+b5bqm5Yqo5oCB6KGoLkJHUF/nu7zlkIjnianljJbmjqLluILlnLrlvIDlj5Hot5/ouKrliqjmgIHooag2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInlnLDljLopNkJHUF/nu7zlkIjnianljJbmjqLku7flgLzlt6XkvZzph4/nu5/orqHooago5oyJ5pa55rOVKS5CR1Bf57u85ZCI54mp5YyW5o6i5YuY5o6i6aG555uu6L+Q5L2c5Yqo5oCB6KGoFCsDEWdnZ2dnZ2dnZ2dnZ2dnZ2dnFgECDWQCAw8PFgIeB1Zpc2libGVnZGQCBQ8PFgIfAWhkFgQCAQ8QDxYCHwBnZBAVAgQyMDA4BDIwMDkVAgQyMDA4BDIwMDkUKwMCZ2cWAWZkAgMPEA8WAh8AZ2QQFQwBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTIVDAExATIBMwE0ATUBNgE3ATgBOQIxMAIxMQIxMhQrAwxnZ2dnZ2dnZ2dnZ2cWAQIEZAIHDw8WAh8BaGRkAgkPDxYCHwFoZBYCAgEPFgIeBXZhbHVlBQkyMDExLTUtMTZkZP1oHBpjroix2Fw4ILAsqulsLFVy"
			,"/wEPDwULLTEwNzUyNjk4NzQPZBYCZg9kFgoCAQ8QDxYCHgtfIURhdGFCb3VuZGdkEBUREumhueebruWcsOWbvuWxleekuiVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6Zeu6aKY57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67nlJ/kuqfnu5/orqHooaglQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCpCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGoKOW5tClDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOWRqOaKpe+8jOWQq+WFqOW5tOmhueebru+8iUNCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGo77yI5pyI5oql77yM5ZCr5YWo5bm06aG555uu77yJP0JHUF/lnLDpnIfli5jmjqLpobnnm67mlr3lt6Xlm6DntKDlj4rorr7lpIfliqjmgIHmiqXooajvvIgyRO+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIM0TvvIklQkdQX+WcsOmch+mHh+mbhumhueebruWHhuWkh+S/oeaBr+ihqCVCR1Bf5Zyw6ZyH6YeH6ZuG6aG555uu57uT5p2f5L+h5oGv6KGoiAFCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu4oCc5YWt5Liq6K6h5YiS44CB6YOo572y5Zu+44CB5pa95bel6K6+6K6h44CB6K+V6aqM5oC757uT44CB5pa95bel5oC757uT44CB55Sy5pa56aqM5pS25Lmm4oCd5Yqg6L295oOF5Ya157uf6K6h6KGoK0JHUF/kupXkuK3lnLDpnIfkuK3lv4Ppobnnm67ov5vluqbliqjmgIHooaguQkdQX+e7vOWQiOeJqeWMluaOouW4guWcuuW8gOWPkei3n+i4quWKqOaAgeihqDZCR1Bf57u85ZCI54mp5YyW5o6i5Lu35YC85bel5L2c6YeP57uf6K6h6KGoKOaMieWcsOWMuik2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInmlrnms5UpLkJHUF/nu7zlkIjnianljJbmjqLli5jmjqLpobnnm67ov5DkvZzliqjmgIHooagVERLpobnnm67lnLDlm77lsZXnpLolQkdQX+WcsOmch+WLmOaOoumhueebrumXrumimOe7n+iuoeihqCVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu55Sf5Lqn57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooagqQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCjlubQpQ0JHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooajvvIjlkajmiqXvvIzlkKvlhajlubTpobnnm67vvIlDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOaciOaKpe+8jOWQq+WFqOW5tOmhueebru+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIMkTvvIk/QkdQX+WcsOmch+WLmOaOoumhueebruaWveW3peWboOe0oOWPiuiuvuWkh+WKqOaAgeaKpeihqO+8iDNE77yJJUJHUF/lnLDpnIfph4fpm4bpobnnm67lh4blpIfkv6Hmga/ooaglQkdQX+WcsOmch+mHh+mbhumhueebrue7k+adn+S/oeaBr+ihqIgBQkdQX+WcsOmch+WLmOaOoumhueebruKAnOWFreS4quiuoeWIkuOAgemDqOe9suWbvuOAgeaWveW3peiuvuiuoeOAgeivlemqjOaAu+e7k+OAgeaWveW3peaAu+e7k+OAgeeUsuaWuemqjOaUtuS5puKAneWKoOi9veaDheWGtee7n+iuoeihqCtCR1Bf5LqV5Lit5Zyw6ZyH5Lit5b+D6aG555uu6L+b5bqm5Yqo5oCB6KGoLkJHUF/nu7zlkIjnianljJbmjqLluILlnLrlvIDlj5Hot5/ouKrliqjmgIHooag2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInlnLDljLopNkJHUF/nu7zlkIjnianljJbmjqLku7flgLzlt6XkvZzph4/nu5/orqHooago5oyJ5pa55rOVKS5CR1Bf57u85ZCI54mp5YyW5o6i5YuY5o6i6aG555uu6L+Q5L2c5Yqo5oCB6KGoFCsDEWdnZ2dnZ2dnZ2dnZ2dnZ2dnFgECDmQCAw8PFgIeB1Zpc2libGVnZGQCBQ8PFgIfAWhkFgQCAQ8QDxYCHwBnZBAVAgQyMDA4BDIwMDkVAgQyMDA4BDIwMDkUKwMCZ2cWAWZkAgMPEA8WAh8AZ2QQFQwBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTIVDAExATIBMwE0ATUBNgE3ATgBOQIxMAIxMQIxMhQrAwxnZ2dnZ2dnZ2dnZ2cWAQIEZAIHDw8WAh8BaGRkAgkPDxYCHwFoZBYCAgEPFgIeBXZhbHVlBQkyMDExLTUtMTZkZEDi6/XDTpp8Jr9x16NhAbit8ZiA"
			,"/wEPDwULLTEwNzUyNjk4NzQPZBYCZg9kFgoCAQ8QDxYCHgtfIURhdGFCb3VuZGdkEBUREumhueebruWcsOWbvuWxleekuiVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6Zeu6aKY57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67nlJ/kuqfnu5/orqHooaglQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCpCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGoKOW5tClDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOWRqOaKpe+8jOWQq+WFqOW5tOmhueebru+8iUNCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGo77yI5pyI5oql77yM5ZCr5YWo5bm06aG555uu77yJP0JHUF/lnLDpnIfli5jmjqLpobnnm67mlr3lt6Xlm6DntKDlj4rorr7lpIfliqjmgIHmiqXooajvvIgyRO+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIM0TvvIklQkdQX+WcsOmch+mHh+mbhumhueebruWHhuWkh+S/oeaBr+ihqCVCR1Bf5Zyw6ZyH6YeH6ZuG6aG555uu57uT5p2f5L+h5oGv6KGoiAFCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu4oCc5YWt5Liq6K6h5YiS44CB6YOo572y5Zu+44CB5pa95bel6K6+6K6h44CB6K+V6aqM5oC757uT44CB5pa95bel5oC757uT44CB55Sy5pa56aqM5pS25Lmm4oCd5Yqg6L295oOF5Ya157uf6K6h6KGoK0JHUF/kupXkuK3lnLDpnIfkuK3lv4Ppobnnm67ov5vluqbliqjmgIHooaguQkdQX+e7vOWQiOeJqeWMluaOouW4guWcuuW8gOWPkei3n+i4quWKqOaAgeihqDZCR1Bf57u85ZCI54mp5YyW5o6i5Lu35YC85bel5L2c6YeP57uf6K6h6KGoKOaMieWcsOWMuik2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInmlrnms5UpLkJHUF/nu7zlkIjnianljJbmjqLli5jmjqLpobnnm67ov5DkvZzliqjmgIHooagVERLpobnnm67lnLDlm77lsZXnpLolQkdQX+WcsOmch+WLmOaOoumhueebrumXrumimOe7n+iuoeihqCVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu55Sf5Lqn57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooagqQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCjlubQpQ0JHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooajvvIjlkajmiqXvvIzlkKvlhajlubTpobnnm67vvIlDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOaciOaKpe+8jOWQq+WFqOW5tOmhueebru+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIMkTvvIk/QkdQX+WcsOmch+WLmOaOoumhueebruaWveW3peWboOe0oOWPiuiuvuWkh+WKqOaAgeaKpeihqO+8iDNE77yJJUJHUF/lnLDpnIfph4fpm4bpobnnm67lh4blpIfkv6Hmga/ooaglQkdQX+WcsOmch+mHh+mbhumhueebrue7k+adn+S/oeaBr+ihqIgBQkdQX+WcsOmch+WLmOaOoumhueebruKAnOWFreS4quiuoeWIkuOAgemDqOe9suWbvuOAgeaWveW3peiuvuiuoeOAgeivlemqjOaAu+e7k+OAgeaWveW3peaAu+e7k+OAgeeUsuaWuemqjOaUtuS5puKAneWKoOi9veaDheWGtee7n+iuoeihqCtCR1Bf5LqV5Lit5Zyw6ZyH5Lit5b+D6aG555uu6L+b5bqm5Yqo5oCB6KGoLkJHUF/nu7zlkIjnianljJbmjqLluILlnLrlvIDlj5Hot5/ouKrliqjmgIHooag2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInlnLDljLopNkJHUF/nu7zlkIjnianljJbmjqLku7flgLzlt6XkvZzph4/nu5/orqHooago5oyJ5pa55rOVKS5CR1Bf57u85ZCI54mp5YyW5o6i5YuY5o6i6aG555uu6L+Q5L2c5Yqo5oCB6KGoFCsDEWdnZ2dnZ2dnZ2dnZ2dnZ2dnFgECD2QCAw8PFgIeB1Zpc2libGVnZGQCBQ8PFgIfAWhkFgQCAQ8QDxYCHwBnZBAVAgQyMDA4BDIwMDkVAgQyMDA4BDIwMDkUKwMCZ2cWAWZkAgMPEA8WAh8AZ2QQFQwBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTIVDAExATIBMwE0ATUBNgE3ATgBOQIxMAIxMQIxMhQrAwxnZ2dnZ2dnZ2dnZ2cWAQIEZAIHDw8WAh8BaGRkAgkPDxYCHwFoZBYCAgEPFgIeBXZhbHVlBQkyMDExLTUtMTZkZKJI/GocwEYwMjln2iV/LYpuRzMF"
			,"/wEPDwULLTEwNzUyNjk4NzQPZBYCZg9kFgoCAQ8QDxYCHgtfIURhdGFCb3VuZGdkEBUREumhueebruWcsOWbvuWxleekuiVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6Zeu6aKY57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67nlJ/kuqfnu5/orqHooaglQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCpCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGoKOW5tClDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOWRqOaKpe+8jOWQq+WFqOW5tOmhueebru+8iUNCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu6L+Q6KGM5Yqo5oCB6KGo77yI5pyI5oql77yM5ZCr5YWo5bm06aG555uu77yJP0JHUF/lnLDpnIfli5jmjqLpobnnm67mlr3lt6Xlm6DntKDlj4rorr7lpIfliqjmgIHmiqXooajvvIgyRO+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIM0TvvIklQkdQX+WcsOmch+mHh+mbhumhueebruWHhuWkh+S/oeaBr+ihqCVCR1Bf5Zyw6ZyH6YeH6ZuG6aG555uu57uT5p2f5L+h5oGv6KGoiAFCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu4oCc5YWt5Liq6K6h5YiS44CB6YOo572y5Zu+44CB5pa95bel6K6+6K6h44CB6K+V6aqM5oC757uT44CB5pa95bel5oC757uT44CB55Sy5pa56aqM5pS25Lmm4oCd5Yqg6L295oOF5Ya157uf6K6h6KGoK0JHUF/kupXkuK3lnLDpnIfkuK3lv4Ppobnnm67ov5vluqbliqjmgIHooaguQkdQX+e7vOWQiOeJqeWMluaOouW4guWcuuW8gOWPkei3n+i4quWKqOaAgeihqDZCR1Bf57u85ZCI54mp5YyW5o6i5Lu35YC85bel5L2c6YeP57uf6K6h6KGoKOaMieWcsOWMuik2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInmlrnms5UpLkJHUF/nu7zlkIjnianljJbmjqLli5jmjqLpobnnm67ov5DkvZzliqjmgIHooagVERLpobnnm67lnLDlm77lsZXnpLolQkdQX+WcsOmch+WLmOaOoumhueebrumXrumimOe7n+iuoeihqCVCR1Bf5Zyw6ZyH5YuY5o6i6aG555uu55Sf5Lqn57uf6K6h6KGoJUJHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooagqQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqCjlubQpQ0JHUF/lnLDpnIfli5jmjqLpobnnm67ov5DooYzliqjmgIHooajvvIjlkajmiqXvvIzlkKvlhajlubTpobnnm67vvIlDQkdQX+WcsOmch+WLmOaOoumhueebrui/kOihjOWKqOaAgeihqO+8iOaciOaKpe+8jOWQq+WFqOW5tOmhueebru+8iT9CR1Bf5Zyw6ZyH5YuY5o6i6aG555uu5pa95bel5Zug57Sg5Y+K6K6+5aSH5Yqo5oCB5oql6KGo77yIMkTvvIk/QkdQX+WcsOmch+WLmOaOoumhueebruaWveW3peWboOe0oOWPiuiuvuWkh+WKqOaAgeaKpeihqO+8iDNE77yJJUJHUF/lnLDpnIfph4fpm4bpobnnm67lh4blpIfkv6Hmga/ooaglQkdQX+WcsOmch+mHh+mbhumhueebrue7k+adn+S/oeaBr+ihqIgBQkdQX+WcsOmch+WLmOaOoumhueebruKAnOWFreS4quiuoeWIkuOAgemDqOe9suWbvuOAgeaWveW3peiuvuiuoeOAgeivlemqjOaAu+e7k+OAgeaWveW3peaAu+e7k+OAgeeUsuaWuemqjOaUtuS5puKAneWKoOi9veaDheWGtee7n+iuoeihqCtCR1Bf5LqV5Lit5Zyw6ZyH5Lit5b+D6aG555uu6L+b5bqm5Yqo5oCB6KGoLkJHUF/nu7zlkIjnianljJbmjqLluILlnLrlvIDlj5Hot5/ouKrliqjmgIHooag2QkdQX+e7vOWQiOeJqeWMluaOouS7t+WAvOW3peS9nOmHj+e7n+iuoeihqCjmjInlnLDljLopNkJHUF/nu7zlkIjnianljJbmjqLku7flgLzlt6XkvZzph4/nu5/orqHooago5oyJ5pa55rOVKS5CR1Bf57u85ZCI54mp5YyW5o6i5YuY5o6i6aG555uu6L+Q5L2c5Yqo5oCB6KGoFCsDEWdnZ2dnZ2dnZ2dnZ2dnZ2dnFgECEGQCAw8PFgIeB1Zpc2libGVnZGQCBQ8PFgIfAWhkFgQCAQ8QDxYCHwBnZBAVAgQyMDA4BDIwMDkVAgQyMDA4BDIwMDkUKwMCZ2cWAWZkAgMPEA8WAh8AZ2QQFQwBMQEyATMBNAE1ATYBNwE4ATkCMTACMTECMTIVDAExATIBMwE0ATUBNgE3ATgBOQIxMAIxMQIxMhQrAwxnZ2dnZ2dnZ2dnZ2cWAQIEZAIHDw8WAh8BaGRkAgkPDxYCHwFoZBYCAgEPFgIeBXZhbHVlBQkyMDExLTUtMTZkZHWIBGYQ4llDUL/g6joGaQsDyRGp"
		);
	var __EVENTVALIDATION = new Array(
			 "/wEWFwLqhqxpAtPziuQGApPczM8EAoqW2sULAobaw8sKAqSPvrgPAv3A2rAMAp2zxaMMAoeCvM8KApjpnmIC+LSFvgwCnJDBrwsCpITx8w8CibGziwoC9c7TnAYCgvaX3Q4C57SCow4C44nf8AwChcPmwQ8CjYuliwYCkouliwYCk4uliwYC9IeAP4ZiGiK2XMAgtNcafeAgXcyk4hRC"
			,"/wEWFwL7hojwCgLT84rkBgKT3MzPBAKKltrFCwKG2sPLCgKkj764DwL9wNqwDAKds8WjDAKHgrzPCgKY6Z5iAvi0hb4MApyQwa8LAqSE8fMPAomxs4sKAvXO05wGAoL2l90OAue0gqMOAuOJ3/AMAoXD5sEPAo2LpYsGApKLpYsGApOLpYsGAvSHgD/sJFDFeaV+6krIzgrbzdF8MAJ6WQ=="
			,"/wEWFwLayYC6AwLT84rkBgKT3MzPBAKKltrFCwKG2sPLCgKkj764DwL9wNqwDAKds8WjDAKHgrzPCgKY6Z5iAvi0hb4MApyQwa8LAqSE8fMPAomxs4sKAvXO05wGAoL2l90OAue0gqMOAuOJ3/AMAoXD5sEPAo2LpYsGApKLpYsGApOLpYsGAvSHgD9Z5ChWqYYZBu538VgMSkmr+7CrJA=="
			,"/wEWFwLe0u3kCgLT84rkBgKT3MzPBAKKltrFCwKG2sPLCgKkj764DwL9wNqwDAKds8WjDAKHgrzPCgKY6Z5iAvi0hb4MApyQwa8LAqSE8fMPAomxs4sKAvXO05wGAoL2l90OAue0gqMOAuOJ3/AMAoXD5sEPAo2LpYsGApKLpYsGApOLpYsGAvSHgD+9f+EOhJa565Fv0B1XskObw6ZjwQ=="
			,"/wEWFwKkjfK2DQLT84rkBgKT3MzPBAKKltrFCwKG2sPLCgKkj764DwL9wNqwDAKds8WjDAKHgrzPCgKY6Z5iAvi0hb4MApyQwa8LAqSE8fMPAomxs4sKAvXO05wGAoL2l90OAue0gqMOAuOJ3/AMAoXD5sEPAo2LpYsGApKLpYsGApOLpYsGAvSHgD8PvH8zYE1LgSW6Ritwkjt5YQmEwQ=="
		);

	function viewERPReport(i,j){
		var form = document.getElementById("form1");
		document.getElementById("__VIEWSTATE").value=__VIEWSTATE[i];
		document.getElementById("__EVENTVALIDATION").value=__EVENTVALIDATION[i];
		document.getElementById("DropDownList1").value=j;
		form.submit();
	}
</script>
</html>