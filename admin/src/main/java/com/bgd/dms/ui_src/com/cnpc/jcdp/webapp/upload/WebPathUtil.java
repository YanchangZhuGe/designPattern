package com.cnpc.jcdp.webapp.upload;

import java.io.File;

/**
 * 
* @ClassName: WebPathUtil
* @Description: ��ȡ��Ŀ·��
* @author wuhj
* @date 2013-9-11 ����7:04:43
*
 */
public class WebPathUtil {
	
	public static String file_path = "gms"+File.separator+"uploadFile";

	public static String getWebProjectPath(){
		
		return System.getProperty("user.dir") ;
	}

}
