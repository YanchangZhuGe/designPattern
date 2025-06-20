package com.nstc.brs.business.account.month;

import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecordDetail;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;

/**
 * 月末对账-每日对账企业未达明细
 * @ClassName QueryMonthDailyListBusiness
 * @Author fmh
 * @Date 2024-11-29
 */
public class QueryMonthDailyListBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthDailyRange_q;
	private List<Map<String, Object>> brs_monthDailyRange_l;
	private String id;

	@SuppressWarnings("unchecked")
	@Override
	public void doExecute() throws Exception {
		if(id == null && brs_monthDailyRange_q != null){
			id = CastUtil.toNotEmptyString(brs_monthDailyRange_q.get("recordId"));
		}
		
		if(brs_monthDailyRange_q != null){
			MonthCheckScope scope = BeanHelper.populate(MonthCheckScope.class, brs_monthDailyRange_q);
			scope.setId(Integer.valueOf(id));
			List<BrsCheckRecordDetail> unDetailList = this.getContext().getAccountService().getUnDaliyDetailList(scope);
			brs_monthDailyRange_l = BeanHelper.describe(unDetailList);
		}
		
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

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	

}
