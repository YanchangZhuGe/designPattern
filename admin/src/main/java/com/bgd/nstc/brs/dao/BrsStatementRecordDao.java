package com.nstc.brs.dao;

import java.util.List;

import com.nstc.brs.domain.BrsStatementRecord;

/** 
 * 
 * @Title 对账记录 
 * @Description: 
 * @author ZCL
 * @date 2014-8-21 下午02:54:50
 */
public interface BrsStatementRecordDao {

	/** 查询最后一条对账记录 */
	public BrsStatementRecord selectLastRecord(BrsStatementRecord qry);
	
	/** 查找最后一条核销记录*/
	public BrsStatementRecord selectLastVerificationRecord(BrsStatementRecord qry);

	/** 新增数据*/
	public Integer insert(BrsStatementRecord record);

	/**查询对账记录*/
	public BrsStatementRecord selectRecord(BrsStatementRecord record);

	/**查询对账记录列表 */
	public List<BrsStatementRecord> selectRecordList(BrsStatementRecord record);

	/**更新数据*/
	public void update(BrsStatementRecord record);


}
