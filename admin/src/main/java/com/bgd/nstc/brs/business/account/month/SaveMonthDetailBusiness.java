package com.nstc.brs.business.account.month;

import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecordDetail;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.enums.MateFlag;
import com.nstc.brs.enums.MateState;
import com.nstc.brs.enums.MateType;
import com.nstc.util.BeanHelper;

/**
 * 保存新增明细信息
 * @ClassName SaveMonthDetailBusiness
 * @Author fmh
 * @Date 2024-11-28
 */
public class SaveMonthDetailBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthCheckAdd_form;

	@Override
	public void doExecute() throws Exception {
		BrsCheckRecordDetail detail = BeanHelper.populate(BrsCheckRecordDetail.class, brs_monthCheckAdd_form);
		detail.setMateType(MateFlag.TYPE_2.getValue());
		//detail.setDetailType(DetailType.TYPE_1.getValue());
		detail.setMateState(MateType.TYPE_2.getValue());
		detail.setCreateName(this.getCaller().getProfile().getUserNo());
		Map<String,Object> retMap = this.getContext().getBrsBankReconciliationService().saveAddRecordMateDetail(detail);
		
		brs_monthCheckAdd_form.put("successFlag", 1);
		brs_monthCheckAdd_form.putAll(retMap);
		this.putResult("brs_monthCheckAdd_form", brs_monthCheckAdd_form);
	}

	public Map<String, Object> getBrs_monthCheckAdd_form() {
		return brs_monthCheckAdd_form;
	}

	public void setBrs_monthCheckAdd_form(Map<String, Object> brs_monthCheckAdd_form) {
		this.brs_monthCheckAdd_form = brs_monthCheckAdd_form;
	}


}
