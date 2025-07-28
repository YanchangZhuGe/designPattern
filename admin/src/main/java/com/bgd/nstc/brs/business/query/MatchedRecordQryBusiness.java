package com.nstc.brs.business.query;

import java.util.List;
import java.util.Map;

import com.nstc.brs.domain.BrsBankRecord;
import com.nstc.brs.domain.BrsVoucher;
import com.nstc.brs.enums.CheckState;
import com.nstc.brs.enums.IsOld;
import com.nstc.brs.enums.MatchMethod;
import com.nstc.brs.handler.R;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.util.CastUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 查询历史匹配记录执行查询
 * @Description: 
 * @author ZCL
 * @date 2014-8-29 上午10:14:51
 */
public class MatchedRecordQryBusiness extends MatchedRecordMainBusiness{
	
	private Map<String,String> brs_qryMatchedRecord_top;
	
	@Override
	public void doExecute() throws Exception {
		CheckAccountQry qry = getQryPara();
		List<BrsVoucher> voucerhList = getContext().getVoucherService().getVoucherList(qry);
		List<BrsBankRecord> recordList = getContext().getBankRecordService().getRecordList(qry);
		putResult(R.SP.QRYMATCHEDRECORD_VOUCHER, BeanHelper.describe(voucerhList));
		putResult(R.SP.QRYMATCHEDRECORD_BANK, BeanHelper.describe(recordList));
		this.putCommonResult();
	}
	
	@Override
	protected void putCommonResult(){
		super.putCommonResult();
		putResult("brs_qryMatchedRecord_top", brs_qryMatchedRecord_top);
	}
	
	
	/** 得到查询条件*/
	protected CheckAccountQry getQryPara(){
		CheckAccountQry qry = BeanHelper.populate(CheckAccountQry.class, brs_qryMatchedRecord_top);
		String matchType = CastUtil.trimNull(brs_qryMatchedRecord_top.get("matchType"));
		//查询只查询非核销状态的数据
		qry.setCheckStates(CheckState.getNomalStates());
		//给查询参数对象 增加 对账方式 是否已达属性
		if(!matchType.equals("")){
			if(matchType.equals("-1")){
				//未达
				qry.setIsOld(IsOld.NO.getValue());
			}else if(matchType.equals("0")){
				//自动对账
				qry.setMatchMethod(MatchMethod.AUTO.getKey());
			}else if(matchType.equals("1")){
				qry.setMatchMethod(MatchMethod.MANUAL.getKey());
			}
		}
		return qry;
	}

	public Map<String, String> getBrs_qryMatchedRecord_top() {
		return brs_qryMatchedRecord_top;
	}

	public void setBrs_qryMatchedRecord_top(
			Map<String, String> brs_qryMatchedRecord_top) {
		this.brs_qryMatchedRecord_top = brs_qryMatchedRecord_top;
	}
}
