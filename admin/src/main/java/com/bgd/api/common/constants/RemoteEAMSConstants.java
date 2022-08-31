package com.bgd.api.common.constants;

/**
 * <p>
 * Title: 电子档案远程调用常量。
 * </p>
 *
 * <p>
 * Description: 电子档案远程调用常量。
 * </p>
 *
 * <p>
 * Company: 九恒星成都信息技术有限公司
 * </p>
 *
 * @author Tian Ye
 * @since 2019-08-06 14:38:17
 */
public class RemoteEAMSConstants {

	/**
	 * 接口编码-批量同步附件
	 */
	public static final String INTERCODE_T02 = "T02";

	/**
	 * 接口编码-批量删除附件
	 */
	public static final String INTERCODE_T03 = "T03";

	/**
	 * 接口编码-删除附件
	 */
	public static final String INTERCODE_T04 = "T04";

	/**
	 * 接口编码-批量同步附件(删除原附件)
	 */
	public static final String INTERCODE_T05 = "T05";

	/**
	 * 接口编码-查询附件类型
	 */
	public static final String INTERCODE_Q01 = "Q01";

	/**
	 * 接口编码-查询基础档案
	 */
	public static final String INTERCODE_Q02 = "Q02";

	/**
	 * 接口编码-查询业务档案
	 */
	public static final String INTERCODE_Q03 = "Q03";

	/**
	 * 接口编码-合同状态变更
	 */
	public static final String INTERCODE_C01 = "C01";

	/**
	 * 参数名-调用接口编码
	 */
	public static final String PARAM_BIZCODE = "bizCode";

	/**
	 * 参数名-调用参数
	 */
	public static final String PARAM_PARAMMAP = "paMap";

	/**
	 * 参数名-调用参数集
	 */
	public static final String PARAM_PARAMLIST = "paList";

	/**
	 * 参数名-结果包装对象
	 */
	public static final String PARAM_RESULT = "result";

	/**
	 * 参数名-结果包装对象-返回结果
	 */
	public static final String PARAM_RESULTMAP = "retMap";

	/**
	 * 参数名-结果包装对象-返回结果集
	 */
	public static final String PARAM_RESULTLIST = "retList";

	/**
	 * 参数名-结果包装对象-返回结果代码
	 */
	public static final String PARAM_RESULTCODE = "retCode";

	/**
	 * 返回结果代码-成功
	 */
	public static final String RESULTCODE_SUCCESS = "000000";

	/**
	 * 返回结果代码-失败
	 */
	public static final String RESULTCODE_FAILURE = "999999";

	/**
	 * 参数名-结果包装对象-返回结果消息
	 */
	public static final String PARAM_RESULTMSG = "retMsg";
}
