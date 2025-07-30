package com.nstc.brs.business.query;

import java.util.Date;

import com.nstc.brs.business.AbstractBRSBusiness;

/**
 * 
 * @Title 查询历史匹配记录
 * @Description: 
 * @author ZCL
 * @date 2014-8-29 上午09:07:24
 */
public class MatchedRecordMainBusiness extends AbstractBRSBusiness {

	@Override
	public void doExecute() throws Exception {
		putCommonResult();
	}
	
	/** 公共参数 */
	protected void putCommonResult(){
		//科目列表
		//putResult("kms", getContext().getAccountService().getKms());
		putResult("kms", getContext().getAccountService().getKmsAndName());
		putResult("today", new Date());
	}

}
