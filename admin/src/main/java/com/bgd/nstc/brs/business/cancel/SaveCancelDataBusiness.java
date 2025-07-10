package com.nstc.brs.business.cancel;

import java.util.List;
import java.util.Map;

import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 取消已保存的对账信息 
 * @Description: 
 * @author ZCL
 * @date 2014-8-27 下午01:50:41
 */
public class SaveCancelDataBusiness extends CancelDataMainBusiness{
	private List<Map<String,String>> brs_cancel_voucher;
	private List<Map<String,String>> brs_cancel_bank;
	
	@SuppressWarnings("unchecked")
	@Override
	public void doExecute() throws Exception {
		List<BrsVoucher> selectedVouchers = (List<BrsVoucher>) getSelectedList(brs_cancel_voucher, BrsVoucher.class);
		List<BrsBankRecord> selectedRecords = (List<BrsBankRecord>) getSelectedList(brs_cancel_bank, BrsBankRecord.class);
		
		getContext().getBankRecordService().deleteBatch(selectedRecords);
		getContext().getVoucherService().deleteBatch(selectedVouchers);
		
		putResult(R.SP.CANCELCHECKEDRECORD_TOP, getBrs_cancelCheckedRecord_top());
		//返回查询结果
		CheckAccountQry qry = buildQryObj();
		List<BrsVoucher> voucherList = getContext().getVoucherService().getVoucherList(qry);
		List<BrsBankRecord> bankRecordList = getContext().getBankRecordService().getRecordList(qry);
		putResult(R.SP.CANCEL_VOUCHER, BeanHelper.describe(voucherList));
		putResult(R.SP.CANCEL_BANK, BeanHelper.describe(bankRecordList));
		putCommonResult();
	}
	
	public List<Map<String, String>> getBrs_cancel_voucher() {
		return brs_cancel_voucher;
	}
	public void setBrs_cancel_voucher(List<Map<String, String>> brs_cancel_voucher) {
		this.brs_cancel_voucher = brs_cancel_voucher;
	}
	public List<Map<String, String>> getBrs_cancel_bank() {
		return brs_cancel_bank;
	}
	public void setBrs_cancel_bank(List<Map<String, String>> brs_cancel_bank) {
		this.brs_cancel_bank = brs_cancel_bank;
	}
	
	
}
