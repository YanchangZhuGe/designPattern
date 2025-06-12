package com.cnpc.sais.ibp.auth2.util;

import java.util.TimerTask;

import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.sais.ibp.auth2.srv.LoginAndMenuTreeSrv;

/**
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ����˽� 2012-09-27
 *       
 * �������Զ�ˢ��Ȩ�޻���
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
