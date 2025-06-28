package com.nstc.brs.business.account.month;

import java.util.*;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.*;

/**
 * 月末对账列表
 * @ClassName QueryMonthCheckListBusiness
 * @Author fmh
 * @Date 2024-11-22
 */
public class QueryMonthCheckListBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthCheck_q;
	private List<Map<String, Object>> brs_monthCheck_l;

	@SuppressWarnings("unchecked")
	@Override
	public void doExecute() throws Exception {
		if(brs_monthCheck_q == null){
			brs_monthCheck_q = new HashMap<String, Object>();
			brs_monthCheck_q.put("mateMonth", TextFormat.formatDate(DateUtil.addMonth(new Date(),-1),"yyyy-MM"));

//			Map<String, Object> map = new HashMap<String, Object>();
//			map.put("curCode", "CNY");
//			List<Map<String, Object>> workDayList = this.getContext().getAccountService().getWorkDay(map);
//			if(workDayList != null && workDayList.size() > 0){
//				brs_monthCheck_q.put("currentWorkDay", workDayList.get(0).get("workDay"));
//				brs_monthCheck_q.put("balanceDate", DateUtil.addDay((Date)workDayList.get(0).get("workDay"), -1));
//			}
		}
		
		MonthCheckScope scope = BeanHelper.populate(MonthCheckScope.class, brs_monthCheck_q);
		String bankAccountNos = CastUtil.toNotEmptyString(brs_monthCheck_q.get("bankAccountNos"));
		if(!StringUtils.isEmpty(bankAccountNos)){
			scope.setAccountArray(bankAccountNos.split(","));
		}
		List<BrsCheckRecord> list = this.getContext().getAccountService().getMonthCheckList(scope);
		Integer orderId = 1;
		Map<String,Object> param = new HashMap<String, Object>();
		for(BrsCheckRecord data:list){
			//实时查询余额
			param.put("accountNo",data.getCheckAccNo());
			param.put("curCode",data.getCurCode());
			param.put("curDate",DateUtil.addDay(DateUtil.getMonthEnd(data.getMateDate()),1));
			Double innerBalance = this.getContext().getBrsBankReconciliationService().getInnerAccBalance(param);
			if(innerBalance.doubleValue()!=data.getInnerBalance().doubleValue()){
				data.setUpdateFlag("updateFlag");
			}
			data.setOrderId(orderId);
			orderId++;
		}
		brs_monthCheck_l = BeanHelper.describe(list);


		this.putResult("brs_monthCheck_q", brs_monthCheck_q);
		this.putResult("brs_monthCheck_l", brs_monthCheck_l);
		this.putResult("bankList", this.getContext().getAccountService().getBankList());
		this.putResult("mateMonthList", this.getMateMonth());
	}
	public List<Map<String,Object>> getMateMonth(){
		List<Map<String,Object>> dataList = new ArrayList<Map<String, Object>>();
		Date curDate = DateUtil.getDate();
		for(int i=1;i<=24;i++){
			Date newDate = DateUtil.addMonth(curDate,0-i);
			Map<String,Object> data = new HashMap<String, Object>();
			String month = TextFormat.formatDate(newDate,"yyyy-MM");
			data.put("value",month);
			data.put("name",month);
			dataList.add(data);
		}
		return dataList;
	}

	public Map<String, Object> getBrs_monthCheck_q() {
		return brs_monthCheck_q;
	}

	public void setBrs_monthCheck_q(Map<String, Object> brs_monthCheck_q) {
		this.brs_monthCheck_q = brs_monthCheck_q;
	}

	public List<Map<String, Object>> getBrs_monthCheck_l() {
		return brs_monthCheck_l;
	}

	public void setBrs_monthCheck_l(List<Map<String, Object>> brs_monthCheck_l) {
		this.brs_monthCheck_l = brs_monthCheck_l;
	}


}
