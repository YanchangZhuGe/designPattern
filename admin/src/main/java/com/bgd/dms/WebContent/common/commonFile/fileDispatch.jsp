<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.mcs.service.qua.service.QualityUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();

	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectType = user.getProjectType();
	String projectInfoNo = user.getProjectInfoNo();
	String isMulti = request.getParameter("isMulti"); //是否是多项目   0但项目；1多项目
	String menuFalg = request.getParameter("menuFalg");  //菜单标识

	//判断是否是井中项目
	
		if("SCQDTZS".equals(menuFalg)){  //生产启动通知书
				if("0".equals(isMulti)){
					request.getRequestDispatcher("commonFilePage.jsp?folder_id=SCQDTZS&business_type=5110000004100001048&business_info=生产启动通知书申请").forward(request,response);
				}else if("1".equals(isMulti)){
					request.getRequestDispatcher("commonFilePages.jsp?folder_id=SCQDTZS&business_type=5110000004100001048&business_info=生产启动通知书申请").forward(request,response);				
				}
		}else if("ZLFXBG".equals(menuFalg)){  //质量分析报告
			if("5000100004000000008".equals(projectType)){
				if("0".equals(isMulti)){
					request.getRequestDispatcher("commonFilePage.jsp?folder_id=ZLFXBG&business_type=5110000004100001025&business_info=质量分析报告申请").forward(request,response);
				}else if("1".equals(isMulti)){
					request.getRequestDispatcher("commonFilePages.jsp?folder_id=ZLFXBG&business_type=5110000004100001025&business_info=质量分析报告申请").forward(request,response);				
				}				
			}else{
				if("0".equals(isMulti)){
				request.getRequestDispatcher("/qua/sProject/quaFile/meeting.jsp").forward(request,response);
				}
			}

		}else if("HYJL".equals(menuFalg)){  //质量会议记录
			if("5000100004000000008".equals(projectType)){
				if("0".equals(isMulti)){
					request.getRequestDispatcher("commonFilePage.jsp?folder_id=HYJL&business_type=5110000004100001035&business_info=质量会议记录申请").forward(request,response);
				}else if("1".equals(isMulti)){
					request.getRequestDispatcher("commonFilePages.jsp?folder_id=HYJL&business_type=5110000004100001035&business_info=质量会议记录申请").forward(request,response);
				}				
			}else{
				if("0".equals(isMulti)){
				request.getRequestDispatcher("/qua/sProject/quaFile/recordList.jsp").forward(request,response);
				}

			}

		}else if("SCRWS".equals(menuFalg)){  //生产任务书
			if("5000100004000000008".equals(projectType)){
				if("0".equals(isMulti)){
					request.getRequestDispatcher("commonFilePage.jsp?folder_id=SCRWS&business_type=5110000004100001048&business_info=生产任务书申请").forward(request,response);
				}else if("1".equals(isMulti)){
					request.getRequestDispatcher("commonFilePages.jsp?folder_id=SCRWS&business_type=5110000004100001048&business_info=生产任务书申请").forward(request,response);
				}				
			}else{
				if("0".equals(isMulti)){
					request.getRequestDispatcher("/pm/taskbook/taskList.jsp").forward(request,response);
				}else if("1".equals(isMulti)){
					request.getRequestDispatcher("/pm/taskbook/taskList.jsp").forward(request,response);
				}	
			}

		}else if("QSBG".equals(menuFalg)){  //请示报告
			if("5000100004000000008".equals(projectType)){
				if("0".equals(isMulti)){
					request.getRequestDispatcher("commonFilePage.jsp?folder_id=QSBG&business_type=5110000004100001048&business_info=请示报告申请").forward(request,response);
				}else if("1".equals(isMulti)){
					request.getRequestDispatcher("commonFilePages.jsp?folder_id=QSBG&business_type=5110000004100001048&business_info=请示报告申请").forward(request,response);
				}				
			}else{
				if("0".equals(isMulti)){
					request.getRequestDispatcher("/pm/consult/consultreportlist.jsp").forward(request,response);
				}else if("1".equals(isMulti)){
					request.getRequestDispatcher("/pm/consult/consultreportlist.jsp").forward(request,response);
				}	
			}

		}else if("JZXMJH".equals(menuFalg)){  //井中项目计划
			if("5000100004000000008".equals(projectType)){
				if("0".equals(isMulti)){
					request.getRequestDispatcher("commonFilePage.jsp?folder_id=JZXMJH&business_type=5110000004100001047&business_info=井中项目计划申请").forward(request,response);
				}else if("1".equals(isMulti)){
					request.getRequestDispatcher("commonFilePages.jsp?folder_id=JZXMJH&business_type=5110000004100001047&business_info=井中项目计划申请").forward(request,response);
				}
			}

		}else if("XCSGJCB".equals(menuFalg)){//现场施工检查表
			if("0".equals(isMulti)){
				request.getRequestDispatcher("commonFilePage.jsp?folder_id=XCSGJCB&business_type=5110000004100001048&business_info=现场施工检查申请").forward(request,response);
			}else if("1".equals(isMulti)){
				request.getRequestDispatcher("commonFilePages.jsp?folder_id=XCSGJCB&business_type=5110000004100001048&business_info=现场施工检查申请").forward(request,response);
			}
		}else if("JZSBQSBG".equals(menuFalg)){//井中设备请示报告
			if("0".equals(isMulti)){
				request.getRequestDispatcher("commonFilePage.jsp?folder_id=JZSBQSBG&business_type=5110000004100001081&business_info=井中设备请示报告申请").forward(request,response);
			}else if("1".equals(isMulti)){
				request.getRequestDispatcher("commonFilePages.jsp?folder_id=JZSBQSBG&business_type=5110000004100001081&business_info=井中设备请示报告申请").forward(request,response);
			}
		}else if("JZSBQSBGJD".equals(menuFalg)){//井中设备请示报告(机动设备)
			if("0".equals(isMulti)){
				request.getRequestDispatcher("commonFilePage.jsp?folder_id=JZSBQSBGJD&business_type=5110000004100001090&business_info=井中设备请示报告申请").forward(request,response);
			}else if("1".equals(isMulti)){
				request.getRequestDispatcher("commonFilePages.jsp?folder_id=JZSBQSBGJD&business_type=5110000004100001090&business_info=井中设备请示报告申请").forward(request,response);
			}
		}else if("JZSBQSBGWZ".equals(menuFalg)){//井中设备请示报告(外租设备)
			if("0".equals(isMulti)){
				request.getRequestDispatcher("commonFilePage.jsp?folder_id=JZSBQSBGWZ&business_type=5110000004100001091&business_info=井中设备请示报告申请").forward(request,response);
			}else if("1".equals(isMulti)){
				request.getRequestDispatcher("commonFilePages.jsp?folder_id=JZSBQSBGWZ&business_type=5110000004100001091&business_info=井中设备请示报告申请").forward(request,response);
			}
		}
	
	
	
	
		
		
	

	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
</html>