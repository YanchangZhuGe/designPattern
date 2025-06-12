package com.bgp.dms.util;

public interface EquipmentStants {

	/** 删除标记：正常 */
	public static final String BSFLAG_ZC = "0";
	/** 删除标记：删除 */
	public static final String BSFLAG_DELETE = "1";
	
	/** 提交状态: 未提交 */
	public static final String BSFLAG_NOSUBMIT = "未提交";
	//public static final String BSFLAG_NOSUBMIT = "3";
	
	/** 提交状态: 待评审 */
	public static final String BSFLAG_NORMAL = "待评审";
	// public static final String BSFLAG_NORMAL = "2";
	
	/** 提交状态: 评审通过 */
	public static final String BSFLAG_TG = "0";
	
	/** 评审状态: 评审未通过 */
	public static final String BSFLAG_WTG = "1";
	
	/** 评审状态: 评审通过 */
	public static final String BSFLAG_TGZT = "评审通过";
	//public static final String BSFLAG_TGZT = "1";
	
	/** 评审未通过状态 */
	public static final String BSFLAG_WTGZT = "评审未通过";
	//public static final String BSFLAG_WTGZT = "0";
	
	/** 首次申请 */
	public static final String BSFLAG_SCSQ = "0";
	
	/** 至期复查 */
	public static final String BSFLAG_ZQFC = "1";
	
	/** 增项 */
	public static final String BSFLAG_ZX = "2";
	
	/** 展开 */
	public static final String BSFLAG_ZK = "true";
	
	/** 否展开*/
	public static final String BSFLAG_BZK = "false";
	
	/** 选择 */
	public static final String BSFLAG_XZ = "true";
	
	/** 否选择 */
	public static final String BSFLAG_BXZ = "false";
	
	/** 成功  success*/
	public static final String BSFLAG_CG = "success";
	
	/** 失败  failed*/
	public static final String BSFLAG_SB = "failed";
}
