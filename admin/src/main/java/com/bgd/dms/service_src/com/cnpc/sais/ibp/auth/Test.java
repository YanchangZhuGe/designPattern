package com.cnpc.sais.ibp.auth;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Properties;

import com.cnpc.sais.ibp.auth2.srv.ProjectAuthMenu;
import com.runqian.report.engine.function.math.Log;

/**   
 * @Title: Test.java
 * @Package com.cnpc.sais.ibp.auth
 * @Description: TODO(用一句话描述该文件做什么)
 * @author wuhj 
 * @date 2014-2-14 上午9:11:29
 * @version V1.0   
 */
public class Test
{

 
	public static void main(String[] args) throws IOException
	{
		ProjectAuthMenu proAuthMenu =	ProjectAuthMenu.getProjectAuthMenu();  
		Properties pro = proAuthMenu.getConfigInfo();
		System.out.println(pro.keySet());
	}

}
