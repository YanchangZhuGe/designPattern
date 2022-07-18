/*================================================================================
 * AccrualType.java
 * 生成日期：2015-9-22 下午02:07:34
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
 * Description:发生额类型
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author zhanghonghui
 * @version 1.0
 * @since：2015-9-22 下午02:07:34
 */
public enum AccrualType implements TypeEnum {

	/**
	 * 存入
	 */
	TYPE_01("01", "存入"),
	/**
	 * 支取
	 */
	TYPE_02("02", "支取"),
	/**
	 * 结息
	 */
	TYPE_03("03", "结息"),
	/**
	 * 支付
	 */
	TYPE_04("04", "支付");
	private String value;
	private String name;

	AccrualType(String value, String name) {
		this.value = value;
		this.name = name;
	}

	public static String getTypeName(String value) {
		for (AccrualType p : values()) {
			if (p.getValue().equals(value)) {
				return p.getName();
			}
		}
		return "";
	}

	/**
	 * @return String
	 */
	public String getValue() {
		return value;
	}

	/**
	 * @param value String
	 */
	public void setValue(String value) {
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
