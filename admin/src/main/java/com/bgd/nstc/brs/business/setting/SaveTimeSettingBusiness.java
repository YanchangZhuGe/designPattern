package com.nstc.brs.business.setting;

import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsTimeSet;
import com.nstc.util.CastUtil;

/**
 * 平账开始时间设置
 * @ClassName SaveTimeSettingBusiness
 * @Author fmh
 * @Date 2024-11-18
 */
public class SaveTimeSettingBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_balcTimeSet_form;

	@Override
	public void doExecute() throws Exception {
		BrsTimeSet set = new BrsTimeSet();
		set.setExeDate(CastUtil.toNotEmptyString(brs_balcTimeSet_form.get("exeDate")));
		set.setSetId(CastUtil.toInteger(brs_balcTimeSet_form.get("setId")));
		set.setUpdateUser(this.getCaller().getProfile().getUserNo());
		this.getContext().getCommonService().saveBrsTimeSet(set);
		this.putResult("brs_balcTimeSet_form", brs_balcTimeSet_form);
	}

	public void setBrs_balcTimeSet_form(Map<String, Object> brs_balcTimeSet_form) {
		this.brs_balcTimeSet_form = brs_balcTimeSet_form;
	}

	public Map<String, Object> getBrs_balcTimeSet_form() {
		return brs_balcTimeSet_form;
	}
	
	
}
