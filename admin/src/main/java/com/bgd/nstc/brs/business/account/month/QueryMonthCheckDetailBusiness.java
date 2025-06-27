package com.nstc.brs.business.account.month;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.domain.BrsCheckRecordDetail;
import com.nstc.brs.enums.AmountDir;
import com.nstc.brs.enums.DetailType;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.brs.util.PageUtils;
import com.nstc.util.BeanHelper;
import com.nstc.util.CastUtil;
import com.nstc.util.MathExtend;
import com.nstc.util.TextFormat;

/**
 * 月末对账未达明细
 * @ClassName QueryMonthCheckDetailBusiness
 * @Author fmh
 * @Date 2024-11-27
 */
public class QueryMonthCheckDetailBusiness extends AbstractBRSBusiness {
	private Map<String, Object> brs_monthCheckDetail_form;
	private List<Map<String, Object>> brs_monthCheckDetail_list;
	private List<Map<String, Object>> brs_monthCheckDetail_list2;
	private String id;

	@SuppressWarnings("unchecked")
	@Override
	public void doExecute() throws Exception {
		if(brs_monthCheckDetail_form != null){
			id = CastUtil.toNotEmptyString(brs_monthCheckDetail_form.get("id"));
		}
		if(id != null){
			MonthCheckScope scope = new MonthCheckScope();
			scope.setId(Integer.valueOf(id));
			List<BrsCheckRecord> list = this.getContext().getAccountService().getMonthCheckList(scope);

			if(list != null && list.size() > 0){
				BrsCheckRecord record = list.get(0);
				Double cpmUnAmount = 0.0;//企业未达明细金额
				Double cpmAmount = 0.0;//企业调节后余额
				Double cpmBalance = record.getInnerBalance();//企业账面余额

				Double umMateAmount = record.getUmMateAmount();//调节前余额差额
				Double mateAmount = 0.0;//调节后余额差额
				Double bankBalance = 0.0;//银行对账单余额

				Double bankUnAmount = 0.0;//银行未达明细金额
				Double bankAmount = 0.0;//银行调节后余额

				this.putResult("cpmBalance", TextFormat.formatCurrency0(record.getInnerBalance()));
//				this.putResult("cpmUnAmount", TextFormat.formatCurrency0(record.getDifDetailAmount()));
				this.putResult("umMateAmount", TextFormat.formatCurrency0(umMateAmount));
				this.putResult("bankBalance", TextFormat.formatCurrency0(record.getBankBalance()));
//				this.putResult("bankUnAmount", TextFormat.formatCurrency0(record.getDifDetailAmount()));
				this.putResult("bankAmount", TextFormat.formatCurrency0(record.getMateAmount()));
				
//				if(brs_monthCheckDetail_form != null){
//					Date startDate = CastUtil.toDate(brs_monthCheckDetail_form.get("startDate"));
//					Date endDate = CastUtil.toDate(brs_monthCheckDetail_form.get("endDate"));
//
//					if(startDate == null){
//						//startDate = record.getMateDate();
//					}else{
//						scope.setId(null);
//					}
//					if(endDate == null){
//						//endDate = record.getMateDate();
//					}else{
//						scope.setId(null);
//					}
//					scope.setStartDate(startDate);
//					scope.setEndDate(endDate);
//				}
				scope.setRecordId(Integer.valueOf(id));
				List<BrsCheckRecordDetail> detailListTotal = this.getContext().getAccountService().getMonthCheckDetailList(scope);
				int totalCount = detailListTotal.size();
				int pageSize = PageUtils.getPageSize(bizEvent, "brs_monthCheckDetail_list", getAppNo());
				int curPageNo = PageUtils.getCurPageNo(bizEvent, "brs_monthCheckDetail_list");
				Map<String,Object> pageInfo = PageUtils.getPageInfoMap(pageSize, curPageNo);
				Integer pageStart = CastUtil.toInteger(pageInfo.get("pageStart"));
				Integer pageEnd = CastUtil.toInteger(pageInfo.get("pageEnd"));
				scope.setPageStart(pageStart);
				scope.setPageEnd(pageEnd);
				List<BrsCheckRecordDetail> detailList = this.getContext().getAccountService().getMonthCheckDetailList(scope);
				brs_monthCheckDetail_list = BeanHelper.describe(detailList);
				this.putResult("brs_monthCheckDetail_list._rowCount", totalCount);
				this.putResult("brs_monthCheckDetail_list._curPageNum", curPageNo);
				Integer payNum = 0;
				Double payAmount= 0.00;
				Integer recNum = 0;
				Double recAmount = 0.00;
				if(detailListTotal != null && detailListTotal.size() > 0){
					for(BrsCheckRecordDetail d : detailListTotal){
						if("2".equals(d.getAmountDir())){
							recNum = recNum + 1;
							recAmount = MathExtend.add(recAmount, d.getAmount());

						}else{
							payNum = payNum + 1;
							payAmount = MathExtend.add(payAmount, d.getAmount());
						}
					}
					cpmUnAmount = MathExtend.subtract(recAmount,payAmount);
				}
				cpmAmount = MathExtend.add(cpmUnAmount,record.getInnerBalance());
				this.putResult("cpmUnAmount", TextFormat.formatCurrency0(cpmUnAmount));
				this.putResult("cpmAmount", TextFormat.formatCurrency0(cpmAmount));
				this.putResult("payNum", payNum);
				this.putResult("payAmount", TextFormat.formatCurrency0(payAmount));
				this.putResult("recNum", recNum);
				this.putResult("recAmount", TextFormat.formatCurrency0(recAmount));
				
				scope.setId(Integer.valueOf(id));
				List<BrsCheckRecordDetail> unDetailListTotal = this.getContext().getAccountService().getUnMonthCheckDetailList(scope);
				int totalCount2 = unDetailListTotal.size();
				int pageSize2 = PageUtils.getPageSize(bizEvent, "brs_monthCheckDetail_list2", getAppNo());
				int curPageNo2 = PageUtils.getCurPageNo(bizEvent, "brs_monthCheckDetail_list2");
				Map<String,Object> pageInfo2 = PageUtils.getPageInfoMap(pageSize2, curPageNo2);
				Integer pageStart2 = CastUtil.toInteger(pageInfo2.get("pageStart"));
				Integer pageEnd2 = CastUtil.toInteger(pageInfo2.get("pageEnd"));
				scope.setPageStart(pageStart2);
				scope.setPageEnd(pageEnd2);
				List<BrsCheckRecordDetail> unDetailList = this.getContext().getAccountService().getUnMonthCheckDetailList(scope);
				brs_monthCheckDetail_list2 = BeanHelper.describe(unDetailList);
				this.putResult("brs_monthCheckDetail_list2._rowCount", totalCount2);
				this.putResult("brs_monthCheckDetail_list2._curPageNum", curPageNo2);
				Integer payNum_ = 0;
				Double payAmount_= 0.00;
				Integer recNum_ = 0;
				Double recAmount_ = 0.00;
				if(unDetailListTotal != null && unDetailListTotal.size() > 0){

					for(BrsCheckRecordDetail d : unDetailListTotal){
						if(AmountDir.TYPE_2.getValue().equals(d.getAmountDir())){
							payNum_ = payNum_ + 1;
							payAmount_ = MathExtend.add(payAmount_, d.getAmount());
						}else{
							recNum_ = recNum_ + 1;
							recAmount_ = MathExtend.add(recAmount_, d.getAmount());
						}
					}
					bankUnAmount = MathExtend.subtract(recAmount_,payAmount_);
				}
				bankAmount = MathExtend.add(bankUnAmount,record.getBankBalance());
				this.putResult("bankUnAmount", TextFormat.formatCurrency0(bankUnAmount));
				this.putResult("bankAmount", TextFormat.formatCurrency0(bankAmount));
				this.putResult("payNumBank", payNum_);
				this.putResult("payAmountBank", TextFormat.formatCurrency0(payAmount_));
				this.putResult("recNumBank", recNum_);
				this.putResult("recAmountBank", TextFormat.formatCurrency0(recAmount_));
				mateAmount = MathExtend.subtract(bankAmount,cpmAmount);
				this.putResult("mateAmount", mateAmount);
			}
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
