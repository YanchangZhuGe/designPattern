package com.cnpc.sais.ibp.auth2.util;

import java.util.TimerTask;

import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.sais.ibp.auth2.srv.LoginAndMenuTreeSrv;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将 2012-09-27
 *       
 * 描述：自动刷新权限缓存
 */
public class LoadAuthCacheTimerTask extends TimerTask {
	
	private ILog log;
	
	public LoadAuthCacheTimerTask() {
		log = LogFactory.getLogger(LoadAuthCacheTimerTask.class);
	}

	@Override
	public void run() {
		log.info("LoadAuthCacheTimerTask ======== BEGIN!");

		if(!LoginAndMenuTreeSrv.reloadAuthCacheRunning){
			
			LoginAndMenuTreeSrv.reloadAuthCacheRunning = true;
			
			AuthInitializor init = new AuthInitializor();
			init.run();	
			
			LoginAndMenuTreeSrv.reloadAuthCacheRunning = false; 
		}

		log.info("LoadAuthCacheTimerTask ======== END!");
	}
}
