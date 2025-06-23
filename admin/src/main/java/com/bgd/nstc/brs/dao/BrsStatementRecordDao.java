package com.nstc.brs.dao;

import java.util.List;

import com.nstc.brs.domain.BrsStatementRecord;

/** 
 * 
 * @Title ���˼�¼ 
 * @Description: 
 * @author ZCL
 * @date 2014-8-21 ����02:54:50
 */
public interface BrsStatementRecordDao {

	/** ��ѯ���һ�����˼�¼ */
	public BrsStatementRecord selectLastRecord(BrsStatementRecord qry);
	
	/** �������һ��������¼*/
	public BrsStatementRecord selectLastVerificationRecord(BrsStatementRecord qry);

	/** ��������*/
	public Integer insert(BrsStatementRecord record);

	/**��ѯ���˼�¼*/
	public BrsStatementRecord selectRecord(BrsStatementRecord record);

	/**��ѯ���˼�¼�б� */
	public List<BrsStatementRecord> selectRecordList(BrsStatementRecord record);

	/**��������*/
	public void update(BrsStatementRecord record);


}
