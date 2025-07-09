package com.nstc.brs.business.cancel;

import java.util.Date;

import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.enums.CheckState;


/**
 * 
 * @Title Ö´ÐÐºËÏú
 * @Description: 
 * @author ZCL
 * @date 2014-8-28 ÏÂÎç05:04:30
 */
public class SaveVerificationBusiness extends VerificationQryBusiness{
	
	@Override
	public void doExecute() throws Exception {
		BrsStatementRecord record = getCheckedRecord();
		record.setCheckTime(new Date());
		record.setLastUpdateTime(new Date());
		record.setCheckState(CheckState.VERIFICATION.getValue());
		getContext().getStatementRecordService().update(record);
		doQuery();
	}
}
