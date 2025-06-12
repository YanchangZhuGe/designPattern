package com.cnpc.jcdp.webapp.upload;

import java.io.File;

/**
 * 
* @ClassName: WebPathUtil
* @Description: 获取项目路径
* @author wuhj
* @date 2013-9-11 下午7:04:43
*
 */
public class WebPathUtil {
	
	public static String file_path = "gms"+File.separator+"uploadFile";

	public static String getWebProjectPath(){
		
		return System.getProperty("user.dir") ;
	}

}
