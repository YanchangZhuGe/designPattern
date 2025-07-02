package com.nstc.brs.business.account.month;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.domain.BrsCheckRecordDetail;
import com.nstc.brs.domain.BrsMateDetailSave;
import com.nstc.brs.enums.AmountDir;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.MathExtend;
import com.nstc.util.TextFormat;

/**
 * 暂存月末对账明细数据
 * @ClassName SaveMonthCheckDetailBusiness
 * @Author fmh
 * @Date 2024-11-30
 */
public class SaveMonthCheckDetailBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthCheckDetail_form;
	private List<Map<String, Object>> brs_monthCheckDetail_list;
	private List<Map<String, Object>> brs_monthCheckDetail_list2;
	private String id;

	@Override
	public void doExecute() throws Exception {

		Integer recordId = CastUtil.toInteger(brs_monthCheckDetail_form.get("id"));
		if(brs_monthCheckDetail_list != null && brs_monthCheckDetail_list.size() > 0){
			String detailType = CastUtil.toNotEmptyString(brs_monthCheckDetail_list.get(0).get("detailType"));
			List<BrsMateDetailSave> dataList = BeanHelper.populate(BrsMateDetailSave.class, this.getGridSelectedRow(brs_monthCheckDetail_list));
			this.getContext().getAccountService().saveMonthCheckDetailSave(detailType, recordId, dataList);
		}
		
		if(brs_monthCheckDetail_list2 != null && brs_monthCheckDetail_list2.size() > 0){
			String detailType = CastUtil.toNotEmptyString(brs_monthCheckDetail_list2.get(0).get("detailType"));
			List<BrsMateDetailSave> dataList = BeanHelper.populate(BrsMateDetailSave.class, this.getGridSelectedRow(brs_monthCheckDetail_list2));
			this.getContext().getAccountService().saveMonthCheckDetailSave(detailType, recordId, dataList);
		}
		
		this.putResult("brs_monthCheckDetail_form", brs_monthCheckDetail_form);
		this.putResult("brs_monthCheckDetail_list", brs_monthCheckDetail_list);
		this.putResult("brs_monthCheckDetail_list2", brs_monthCheckDetail_list2);
	}

	

	public void setId(String id) {
		this.id = id;
	}

	public String getId() {
		return id;
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
