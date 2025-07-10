package com.nstc.brs.business.cancel;

import java.util.List;

import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 查询结果
 * @Description: 
 * @author ZCL
 * @date 2014-8-27 上午11:55:06
 */
public class CancelDataQueryBusiness extends CancelDataMainBusiness {
	@Override
	public void doExecute() throws Exception {
		putCommonResult();
		CheckAccountQry qry = buildQryObj();
		List<BrsVoucher> voucherList = getContext().getVoucherService().getVoucherList(qry);
		List<BrsBankRecord> bankRecordList = getContext().getBankRecordService().getRecordList(qry);
		putResult(R.SP.CANCEL_VOUCHER, BeanHelper.describe(voucherList));
		putResult(R.SP.CANCEL_BANK, BeanHelper.describe(bankRecordList));
		putResult(R.SP.CANCELCHECKEDRECORD_TOP, getBrs_cancelCheckedRecord_top());
	}

}
