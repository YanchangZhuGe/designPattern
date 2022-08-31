/**
 *
 */
package com.bgd.api.common.constants;

/**
 * <p>Title: </p>
 *
 * <p>Description: 远程调用静态变量维护</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author yangliye
 *
 * @since：2016年9月6日 上午9:42:24
 *
 */

/**
 * @author Administrator
 *
 */
public class RemoteConstants {
	/**模块名*/
	public static final String MODULE_NAME = "GWMS-Service";
	/**远程调用编码名称*/
	public static final String BIZCODE = "bizCode";
	/**远程调用参数map名*/
	public static final String PARAM = "param";
	/**参数列表*/
	public static final String PARAM_LIST = "paramList";
	/**返回数据集*/
	public static final String RESULT_DATA = "resultData";
	/**返回结果*/
	public static final String RESULT_CODE = "retCode";
	/**返回结果成功*/
	public static final int SUCCESS = 0;
	/**返回结果失败*/
	public static final int FAILURE = -1;
	/**返回结果成功*/
	public static final String GWMS_SUCCESS = "000000";
	/**返回结果失败*/
	public static final String GWMS_FAILURE = "999999";
	/**返回错误信息*/
	public static final String RESULT_MSG = "retMsg";
	/**返回list集合*/
	public static final String RESULT_LIST = "resultList";
	/**返回Map*/
	public static final String RESULT_MAP = "resultMap";
	//远程调用编码维护
	/**记录台账*/
	public static final String HTFSEDJ = "HTFSEDJ";
	/**删除台账*/
	public static final String HTFSEDJSC = "HTFSEDJSC";
	public static final String T01 = "T01";
	public static final String T02 = "T02";
	public static final String T03 = "T03";
	public static final String T04 = "T04";
	public static final String T05 = "T05";
	public static final String T06 = "T06";
	public static final String T07 = "T07";
	public static final String T08 = "T08";
	public static final String T09 = "T09";

	public static final String EDIT = "edit";
	public static final String APPLY = "apply";
	public static final String REGIST = "regist";
	public static final String REGISTINS = "registins";

	//投资理财质押start
	public static final Integer ON_PLEDGE = 1;//质押
	public static final Integer OFF_PLEDGE = 0;//解质押
	//投资理财质押end
}
