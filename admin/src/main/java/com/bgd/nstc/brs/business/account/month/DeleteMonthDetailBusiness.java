package com.nstc.brs.business.account.month;

import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.util.CastUtil;

/**
 * É¾³ýÔÂÄ©¶ÔÕËÃ÷Ï¸
 * @ClassName DeleteMonthDetailBusiness
 * @Author fmh
 * @Date 2024-11-29
 */
public class DeleteMonthDetailBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthCheckDetail_form;
	private List<Map<String, Object>> brs_monthCheckDetail_list;
	private List<Map<String, Object>> brs_monthCheckDetail_list2;

	@SuppressWarnings("unchecked")
	@Override
	public void doExecute() throws Exception {
		//String detailType = CastUtil.toNotEmptyString(brs_monthCheckDetail_form.get("detailType"));
		List<Map<String, Object>> innerList = this.getGridSelectedRow(brs_monthCheckDetail_list);
		List<Map<String, Object>> bankList = this.getGridSelectedRow(brs_monthCheckDetail_list2);
		
		if(innerList != null){
			for(Map<String, Object> m : innerList){
				this.getContext().getAccountService().deleteMonthCheckDetail(m);
			}
		}
		
		if(bankList != null){
			for(Map<String, Object> m : bankList){
				this.getContext().getAccountService().deleteMonthCheckDetail(m);
			}
		}
	}

	public Map<String, Object> getBrs_monthCheckDetail_form() {
		return brs_monthCheckDetail_form;
	}

	public void setBrs_monthCheckDetail_form(
			Map<String, Object> brs_monthCheckDetail_form) {
		this.brs_monthCheckDetail_form = brs_monthCheckDetail_form;
	}

	public List<Map<String, Object>> getBrs_monthCheckDetail_list() {
		return brs_monthCheckDetail_list;
	}

	public void setBrs_monthCheckDetail_list(
			List<Map<String, Object>> brs_monthCheckDetail_list) {
		this.brs_monthCheckDetail_list = brs_monthCheckDetail_list;
	}

	public List<Map<String, Object>> getBrs_monthCheckDetail_list2() {
		return brs_monthCheckDetail_list2;
	}

	public void setBrs_monthCheckDetail_list2(
			List<Map<String, Object>> brs_monthCheckDetail_list2) {
		this.brs_monthCheckDetail_list2 = brs_monthCheckDetail_list2;
	}
	
	

}
