package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsBalanceStatic;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.domain.BrsMateDetailSave;
import com.nstc.brs.domain.scope.RecordCommonScope;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.DateUtil;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * ∆•≈‰∆Û“µ√˜œ∏
 * @ClassName DoMateByDateBusiness
 * @Author fmh
 * @Date 2024-12-2
 */
public class DoMateByDateBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthCheckDetail_form;
	private List<Map<String, Object>> brs_monthCheckDetail_list;
	private List<Map<String, Object>> brs_monthCheckDetail_list2;
	private String id;

	@Override
	public void doExecute() throws Exception {
		Integer id = CastUtil.toInteger(brs_monthCheckDetail_form.get("id"));
		MonthCheckScope scope = new MonthCheckScope();
		scope.setId(id);
		List<BrsCheckRecord> list = this.getContext().getAccountService().getMonthCheckList(scope);
		BrsCheckRecord main = list.get(0);
		Map<String, Object> param = new HashMap<String, Object>();
		if(brs_monthCheckDetail_list != null){
			param.put("bankRecordList",this.getGridSelectedRow(brs_monthCheckDetail_list));
		}
		RecordCommonScope commScope = new RecordCommonScope();
		Date qryDate = CastUtil.toDate(brs_monthCheckDetail_form.get("qryDate"));
		commScope.setCurCode(main.getCurCode());
		commScope.setCheckAccNo(main.getCheckAccNo());
		commScope.setRemoveFlag("removeFlag");
		commScope.setStartDate(qryDate);
		commScope.setEndDate(DateUtil.addDay(qryDate,1));
		param.put("innerRecordList",this.getContext().getCommonService().getInnerRecordList(commScope));
		param.put("bankNo",main.getBankNo());
		param.put("mainId",id);
		this.getContext().getBrsBankReconciliationService().saveMateByDate(param);
		
		this.putResult("brs_monthCheckDetail_form", brs_monthCheckDetail_form);
		this.putResult("successFlag", "1");
	}

	public BrsBalanceStatic convertData(BrsCheckRecord record){
		BrsBalanceStatic statics = new BrsBalanceStatic();
		statics.setRecordId(record.getId());
		statics.setMakeDate(DateUtil.getDate());
		statics.setBalanceDate(record.getMateDate());
		statics.setBankAccountNo(record.getBankAccountNo());
		statics.setBankBalance(record.getBankBalance());
		statics.setBussBalance(record.getInnerBalance());
		statics.setOpName(this.getCaller().getProfile().getUserNo());
		statics.setAmount(record.getMateAmount());
		statics.setUmMateAmount(record.getUmMateAmount());
		return statics;
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
