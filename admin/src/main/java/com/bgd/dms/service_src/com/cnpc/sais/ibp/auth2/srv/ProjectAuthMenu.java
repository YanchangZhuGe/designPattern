package com.cnpc.sais.ibp.auth2.srv;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Properties;

/**
 * @Title: ProjectAuthMenu.java
 * @Package com.cnpc.sais.ibp.auth2.srv
 * @Description: TODO(用一句话描述该文件做什么)
 * @author wuhj
 * @date 2014-2-14 上午9:25:09
 * @version V1.0
 */
public class ProjectAuthMenu
{

	private static Properties pro = new Properties();

	private static ProjectAuthMenu projectAuthMenu = null;

	private ProjectAuthMenu()
	{
	};

	public static ProjectAuthMenu getProjectAuthMenu()
	{
		if (projectAuthMenu == null)
		{
			InputStream ins = Thread.currentThread().getContextClassLoader()
					.getResourceAsStream("/auth_menu_project.properties");

			try
			{
				pro.load(ins);
			} catch (IOException e)
			{
				e.printStackTrace();
			}

			projectAuthMenu = new ProjectAuthMenu();
		}
		return projectAuthMenu;
	}

	public Properties getConfigInfo()
	{
		return pro;
	}

}
