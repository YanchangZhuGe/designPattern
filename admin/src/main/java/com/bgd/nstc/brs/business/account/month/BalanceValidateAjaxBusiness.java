package com.nstc.brs.business.account.month;

import java.util.List;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.domain.BrsCheckRecordDetail;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.util.CollectionUtils;
import com.nstc.util.MathExtend;

/**
 * 校验余额调节表
 * @ClassName BalanceValidateAjaxBusiness
 * @Author fmh
 * @Date 2024-12-3
 */
public class BalanceValidateAjaxBusiness extends AbstractBRSBusiness {
	private String recordIds;

	@Override
	public void doExecute() throws Exception {
		String msg = "";
//		if(recordIds != null){
//			String[] ids = recordIds.split(",");
//			if(ids.length > 0){
//				MonthCheckScope scope = new MonthCheckScope();
//				scope.setRecordIds(ids);
//				List<BrsCheckRecord> dataList = this.getContext().getAccountService().getMonthCheckList(scope);
//				if(!CollectionUtils.isEmpty(dataList)){
//					boolean isBankDiff = true;
//					for(BrsCheckRecord record : dataList){
//						MonthCheckScope s = new MonthCheckScope();
//						s.setId(record.getId());
//						s.setRecordId(record.getId());
//						List<BrsCheckRecordDetail> detailList = this.getContext().getAccountService().getMonthCheckDetailList(s);
//						if(detailList != null && detailList.size() > 0){
//							isBankDiff = false;
//							Double sumSaveAmount = 0.00;
//							Double sumAmount = 0.00;
//							for(BrsCheckRecordDetail d : detailList){
//								if(d.getIsSave() == 1){
//									sumSaveAmount = MathExtend.add(sumSaveAmount, d.getAmount());
//								}
//								sumAmount = MathExtend.add(sumAmount, d.getAmount());
//							}
//
////							if(sumSaveAmount > 0){
////								if(MathExtend.subtract(sumSaveAmount, record.getDifDetailAmount()) != 0){
////									msg = msg + "," + record.getBankAccountNo();
////								}
////							}else{
////								if(MathExtend.subtract(sumAmount, record.getDifDetailAmount()) != 0){
////									msg = msg + "," + record.getBankAccountNo();
////								}
////							}
//						}
//						List<BrsCheckRecordDetail> bankDetailList = this.getContext().getAccountService().getUnMonthCheckDetailList(s);
//						if(isBankDiff && bankDetailList != null && bankDetailList.size() > 0){
//							Double sumSaveAmount = 0.00;
//							Double sumAmount = 0.00;
//							for(BrsCheckRecordDetail d : bankDetailList){
//								if(d.getIsSave() == 1){
//									sumSaveAmount = MathExtend.add(sumSaveAmount, d.getAmount());
//								}
//								sumAmount = MathExtend.add(sumAmount, d.getAmount());
//							}
//
////							if(sumSaveAmount > 0){
////								if(MathExtend.subtract(sumSaveAmount, record.getDifDetailAmount()) != 0){
////									msg = msg + "," + record.getBankAccountNo();
////								}
////							}else{
////								if(MathExtend.subtract(sumAmount, record.getDifDetailAmount()) != 0){
////									msg = msg + "," + record.getBankAccountNo();
////								}
////							}
//						}
//					}
//					if(!"".equals(msg)){
//						msg = msg.substring(1) + "账号，调节后余额差额不为0，请确认";
//					}
//
//				}
//			}
//		}
		
		this.putResult("msg", msg);
	}

	public void setRecordIds(String recordIds) {
		this.recordIds = recordIds;
	}

	public String getRecordIds() {
		return recordIds;
	}
	
	
}
