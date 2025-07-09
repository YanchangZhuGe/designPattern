package com.nstc.brs.business.cancel;

import java.util.Date;
import java.util.Map;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.enums.CheckState;
import com.nstc.brs.enums.IsOld;
import com.nstc.brs.enums.MatchMethod;
import com.nstc.brs.model.CheckAccountQry;
import com.nstc.brs.util.CastUtil;
import com.nstc.util.BeanHelper;

/**
 * 
 * @Title 取消历史数据
 * @Description: 
 * @author ZCL
 * @date 2014-8-27 上午10:46:02
 */
public class CancelDataMainBusiness extends AbstractBRSBusiness{

	private Map<String,String> brs_cancelCheckedRecord_top;
	
	@Override
	public void doExecute() throws Exception {
		putCommonResult();
	}

	/** 公用的参数 */
	protected void putCommonResult(){
		//科目列表
		//putResult("kms", getContext().getAccountService().getKms());
		putResult("kms", getContext().getAccountService().getKmsAndName());
		putResult("initStartDate", new Date());
		putResult("initEndDate", new Date());
	}
	
	protected CheckAccountQry buildQryObj(){
		CheckAccountQry result = BeanHelper.populate(CheckAccountQry.class, brs_cancelCheckedRecord_top);
		//查询只查询非核销状态的数据
		result.setCheckStates(CheckState.getNomalStates());
		String matchType = CastUtil.trimNull(brs_cancelCheckedRecord_top.get("matchType"));
		//给查询参数对象 增加 对账方式 是否已达属性
		if(!matchType.equals("")){
			if(matchType.equals("-1")){
				//未达
				result.setIsOld(IsOld.NO.getValue());
			}else if(matchType.equals("0")){
				//自动对账
				result.setMatchMethod(MatchMethod.AUTO.getKey());
			}else if(matchType.equals("1")){
				result.setMatchMethod(MatchMethod.MANUAL.getKey());
			}
		}
		return result;
	}

	public Map<String, String> getBrs_cancelCheckedRecord_top() {
		return brs_cancelCheckedRecord_top;
	}

	public void setBrs_cancelCheckedRecord_top(
			Map<String, String> brs_cancelCheckedRecord_top) {
		this.brs_cancelCheckedRecord_top = brs_cancelCheckedRecord_top;
	}
	
}
