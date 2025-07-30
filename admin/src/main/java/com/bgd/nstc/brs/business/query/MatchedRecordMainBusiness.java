package com.nstc.brs.business.query;

import java.util.Date;

import com.nstc.brs.business.AbstractBRSBusiness;

/**
 * 
 * @Title ��ѯ��ʷƥ���¼
 * @Description: 
 * @author ZCL
 * @date 2014-8-29 ����09:07:24
 */
public class MatchedRecordMainBusiness extends AbstractBRSBusiness {

	@Override
	public void doExecute() throws Exception {
		putCommonResult();
	}
	
	/** �������� */
	protected void putCommonResult(){
		//��Ŀ�б�
		//putResult("kms", getContext().getAccountService().getKms());
		putResult("kms", getContext().getAccountService().getKmsAndName());
		putResult("today", new Date());
	}

}
