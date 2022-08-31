package designPattern.behavior.iterator.enums;

/**
 * <p>Title: DataPermissionStateEnum.java</p>
 *
 * <p>Description: 数据数据是否启用常量</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wangshenglang
 * @since：2018-9-22 上午11:19:55
 */
public enum DataPermissionStateEnum {

	ENABLED("1", "启用"),
	DISABLED("0", "禁用");

	private String code;
	private String name;

	private DataPermissionStateEnum(String code, String name) {
		this.code = code;
		this.name = name;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getCode() {
		return code;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

}
