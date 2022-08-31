package com.bgd.api.common.constants;

/**
 * <p>Title: CommonConstant.java</p>
 *
 * <p>Description: 担保模块常量类</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wangshenglang
 * @since：2018-10-20 下午07:31:11
 */
public class GwmsCommonConstant {

	/**
	 * 财资公参数据权限是否启用的参数编号
	 */
	public static final String DATA_PERMISSION = "USE_USERPER";

	// 抵扣池开关
	public static final Integer ON = 1;
	public static final Integer OFF = 2;

	/**
	 * 自动编码，常量，多用于原本记录当前登录信息,但是由于接口或者自动任务导致没有当前登录信息时的默认值
	 */
	public static final String AUTO = "auto";

	/**
	 * 自动名称，常量，多用于原本记录当前登录信息,但是由于接口或者自动任务导致没有当前登录信息时的默认值
	 */
	public static final String AUTO_NAME = "机制";

	/**
	 * 数据权限为空时默认放入的值，防止没有权限反而查出所有数据的问题
	 */
	public static final String NO_DATA_AUTH = "UNKNOWN";

	/**
	 * 数据权限有时候没有获取到数据返回的null字符串，注意不是null，儿是null字符串，发现会导致sql报错问题
	 */
	public static final String STR_NULL = "null";
	public static final String STR_NULL_UPPER = "NULL";

	/**
	 * 分页大小不限制的值
	 */
	public static final Long MAX_PAGE_SIZE_UNLIMITED = Long.valueOf(-1);
	public static final Long MAX_PAGE_SIZE = Long.valueOf(99999999);

	/**
	 * 接口正常返回的编码
	 */
	public static final Integer RESPONSE_OK = 200;

}
