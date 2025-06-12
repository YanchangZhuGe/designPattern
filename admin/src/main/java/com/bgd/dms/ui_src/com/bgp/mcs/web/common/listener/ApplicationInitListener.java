package com.bgp.mcs.web.common.listener;

import java.io.File;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.bgp.gms.service.flexpaper.DocConverter;
/**
 * 
 * 标题：执行应用程序初始化功能
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将
 *
 * 创建日期：2012-7-24
 * 
 * 描述：
 */
public class ApplicationInitListener implements ServletContextListener {
	
	public static String APP_PATH = null;

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {

	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		
		ServletContext context = event.getServletContext();

		APP_PATH = context.getRealPath("/");
		
		//如何是JBOSS服务器，去掉路径中的./
		if(APP_PATH.indexOf("jboss")!=-1){
			APP_PATH = APP_PATH.replaceAll("./tmp/deploy", "tmp/deploy");
		}
		
		context.setAttribute("fusionChartsURL", "/FusionCharts_Enterprise");
		
		context.setAttribute("fusionWidgetsURL", "/FusionWidgets_Enterprise");
		
		context.setAttribute("fusionMapsURL", "/FusionMaps_Enterprise");
		
		context.setAttribute("powerChartsURL", "/PowerCharts_Enterprise");

	}

}
