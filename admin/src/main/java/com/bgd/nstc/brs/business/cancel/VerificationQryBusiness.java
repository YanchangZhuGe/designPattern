package com.nstc.brs.business.cancel;

import java.util.List;

import com.nstc.brs.domain.BrsStatementRecord;
import com.nstc.brs.handler.R;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 查询结果
 * @Description: 
 * @author ZCL
 * @date 2014-8-28 下午03:16:26
 */
public class VerificationQryBusiness extends VerificationMainBusiness{

	@Override
	public void doExecute() throws Exception {
		doQuery();
	}
	
	protected void doQuery() {
		BrsStatementRecord qry = BeanHelper.populate(BrsStatementRecord.class, getBrs_verification_top());
		List<BrsStatementRecord> recordList = getContext().getStatementRecordService().getRecordList(qry);
		putResult(R.SP.VERIFICATION_LIST, BeanHelper.describe(recordList));
		putResult(R.SP.VERIFICATION_TOP, getBrs_verification_top());
		putCommonResult();
	}
}
