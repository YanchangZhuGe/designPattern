<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="com.bgp.mcs.service.pm.service.dailyReport.AuditDailyReportThread" %>
<%@page import="com.cnpc.jcdp.dao.IJdbcDao" %>
<%@page import="com.bgp.mcs.service.pm.service.p6.util.*" %>
<%@page import="com.bgp.gms.service.op.util.*" %>
<%@page import="com.bgp.mcs.service.doc.service.MyUcm" %>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%
//SynUtils synUtils = new SynUtils();

//synUtils.synProject();
/* String s1 = synUtils.getFilter("synActivityGMStoP6");
synUtils.synActivityGMStoP6(s1); 
synUtils.setUpdateDate("synActivityGMStoP6"); */

/* String s2 = synUtils.getFilter("synActivityP6toGMS");
synUtils.synActivityP6toGMS(s2); 
synUtils.setUpdateDate("synActivityP6toGMS");

String s3 = synUtils.getFilter("synWbsP6toGMS");
synUtils.synWbsP6toGMS(s3);
synUtils.setUpdateDate("synWbsP6toGMS");
synUtils.syncP6DeletedDatas();//删除同步器
synUtils.synProject();//项目同步
synUtils.synBaselineProject();//目标项目同步
synUtils.syncBaseProjectId();//同步项目的目标项目编号 */


//synUtils.synActivityP6toGMS("ProjectId='newProj_-1568210383 - B1'");
//synUtils.synWbsP6toGMS("ProjectId='newProj_-1568210383 - B1'");
//synUtils.synActivityGMStoP6("ProjectId='newProj_1852051282'");
//synUtils.synActivityP6toGMS("ProjectId='newProj_1126661011'");
/* System.out.println("开始同步Activity");

System.out.println("同步Activity结束");
System.out.println("开始同步WBS");

System.out.println("同步WBS结束");  */
/* synUtils.syncP6DeletedDatas();//删除同步器
synUtils.synProject();//项目同步
synUtils.synBaselineProject();//目标项目同步
synUtils.syncBaseProjectId();//同步项目的目标项目编号 */
//synUtils.synProject();//项目同步
//synUtils.synBaselineProject();//目标项目同步
//synUtils.syncBaseProjectId();//同步项目的目标项目编号


//OPCommonUtil.saveProjectHealthInfo("8ad88271481fcd69014820b11b84027f");
//项目文档目录维护
/* UserToken user = OMSMVCUtil.getUserToken(request);
MyUcm m = new MyUcm();
m.createProjectFolderNew(
		"8ad8827148861b7b014888896ed303d9",
		"YH22-24H井压裂监测项目", 
		"9058978BDFDE90C6E0430A15081290C6",
		user.getCodeAffordOrgID(), 
		user.getSubOrgIDofAffordOrg(),
		"5000100004000000008"); */
%>