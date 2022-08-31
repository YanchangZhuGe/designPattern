/*================================================================================
 * GuaranteeLogType.java
 * 生成日期：2015-11-3 上午11:27:35
 * 作          者：zhanghonghui
 * 项          目：GWMS-Service
 * (C)COPYRIGHT BY NSTC.
 * ================================================================================
 */
package designPattern.behavior.iterator.enums;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:反担保类型枚举
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author hsw
 * @version 1.0
 * @since：2018-3-12 上午11:27:35
 */
public enum CounterTypeEnum implements TypeEnum {
	T_0(new Integer(0), "质押"),
	T_1(new Integer(1), "抵押"),
	T_2(new Integer(2), "保证");
	private Integer value;
	private String name;

	CounterTypeEnum(Integer value, String name) {
		this.value = value;
		this.name = name;
	}

	public static String getTypeName(Integer value) {
		for (CounterTypeEnum t : values()) {
			if (t.getValue().equals(value)) {
				return t.getName();
			}
		}
		return "";
	}

	/**
	 * @return String
	 */
	public Integer getValue() {
		return value;
	}

	/**
	 * @param value String
	 */
	public void setValue(Integer value) {
		this.value = value;
	}

	/**
	 * @return String
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name String
	 */
	public void setName(String name) {
		this.name = name;
	}

}
