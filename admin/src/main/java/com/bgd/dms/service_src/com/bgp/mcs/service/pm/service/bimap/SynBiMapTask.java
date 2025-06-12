package com.bgp.mcs.service.pm.service.bimap;

import java.util.TimerTask;

import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;

public class SynBiMapTask extends TimerTask {
	
	private ILog log;
	
	public SynBiMapTask() {
		log = LogFactory.getLogger(SynBiMapTask.class);
	}
	@Override
	public void run() {
		// TODO Auto-generated method stub
		log.info("SynBiMapTask ======== BEGIN!");
		try {
			BiMapUtils mapUtils = new BiMapUtils();
			mapUtils.synMapInfoGMStoBI();
			//更新定时器上一次的执行时间
			mapUtils.setUpdateDate();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		log.info("SynBiMapTask ======== END!");
	}

}
