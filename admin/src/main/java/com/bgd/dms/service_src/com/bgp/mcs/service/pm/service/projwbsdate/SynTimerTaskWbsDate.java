package com.bgp.mcs.service.pm.service.projwbsdate;

import java.util.TimerTask;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;

public class SynTimerTaskWbsDate extends TimerTask {
	
	private ILog log;
	
	public SynTimerTaskWbsDate() {
		log = LogFactory.getLogger(SynTimerTaskWbsDate.class);
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		log.info("SynTimerTaskWbsDate ======== BEGIN!");
		try {
//			SynWbsDateUtils wbsDateUtils = new SynWbsDateUtils();
//			wbsDateUtils.synWbsDates();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		log.info("SynTimerTaskWbsDate ======== END!");
		for(;;){
			
		}
	}

}
