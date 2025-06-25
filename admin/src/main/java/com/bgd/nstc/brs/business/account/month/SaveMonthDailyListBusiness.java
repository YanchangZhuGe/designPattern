package com.nstc.brs.business.account.month;

import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecordDetail;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.enums.MateFlag;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;

/**
 * 月末对账-每日对账企业未达明细
 * @ClassName QueryMonthDailyListBusiness
 * @Author fmh
 * @Date 2024-11-29
 */
public class SaveMonthDailyListBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthDailyRange_q;
	private List<Map<String, Object>> brs_monthDailyRange_l;

	@SuppressWarnings("unchecked")
	@Override
	public void doExecute() throws Exception {
		List<Map<String, Object>> dataList = this.getGridSelectedRow(brs_monthDailyRange_l);
		if(dataList != null && dataList.size() > 0){
			Integer recordId = CastUtil.toInteger(brs_monthDailyRange_q.get("recordId"));
			for(Map<String, Object> d : dataList){
				BrsCheckRecordDetail detail = BeanHelper.populate(BrsCheckRecordDetail.class, d);
				detail.setMateType(MateFlag.TYPE_2.getValue());
				detail.setDetailType(DetailType.TYPE_2.getValue());
				detail.setMateState(MateFlag.TYPE_2.getValue());
				detail.setCreateName(this.getCaller().getProfile().getUserNo());
				detail.setRecordId(recordId);
				this.getContext().getAccountService().saveMonthCheckDetail(detail);
			}
		}
		
		brs_monthDailyRange_q.put("successFlag", 1);
		this.putResult("brs_monthDailyRange_q", brs_monthDailyRange_q);
		this.putResult("brs_monthDailyRange_l", brs_monthDailyRange_l);
	}

	public Map<String, Object> getBrs_monthDailyRange_q() {
		return brs_monthDailyRange_q;
	}

	public void setBrs_monthDailyRange_q(Map<String, Object> brs_monthDailyRange_q) {
		this.brs_monthDailyRange_q = brs_monthDailyRange_q;
	}

	public List<Map<String, Object>> getBrs_monthDailyRange_l() {
		return brs_monthDailyRange_l;
	}

	public void setBrs_monthDailyRange_l(
			List<Map<String, Object>> brs_monthDailyRange_l) {
		this.brs_monthDailyRange_l = brs_monthDailyRange_l;
	}


}
