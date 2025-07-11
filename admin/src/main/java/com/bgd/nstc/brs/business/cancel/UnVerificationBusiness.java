package com.nstc.brs.business.cancel;

import java.util.Date;

import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.enums.CheckState;


/**
 * 
 * @Title ·´ºËÏú
 * @Description: 
 * @author ZCL
 * @date 2014-8-28 ÏÂÎç05:04:30
 */
public class UnVerificationBusiness extends VerificationQryBusiness{
	
	@Override
	public void doExecute() throws Exception {
		BrsStatementRecord record = getCheckedRecord();
		record.setCheckTime(new Date());
		record.setLastUpdateTime(new Date());
		record.setCheckState(CheckState.UNVERIFICATION.getValue());
		getContext().getStatementRecordService().update(record);
		doQuery();
	}
}
