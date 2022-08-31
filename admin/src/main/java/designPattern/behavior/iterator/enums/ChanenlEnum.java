package designPattern.behavior.iterator.enums;

/**
 * <p>Title: ChanenlEnum.java</p>
 *
 * <p>Description: 模块来源枚举类 </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author 作者 李阳
 * @since：2018-9-7 下午01:23:46
 */
public enum ChanenlEnum {
	/**
	 * 信用证管理
	 */
	LCMS("LCMS", "信用证管理");


	private String key;
	private String valueS;

	private ChanenlEnum(String key, String valueS) {
		this.key = key;
		this.valueS = valueS;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValueS() {
		return valueS;
	}

	public void setValueS(String valueS) {
		this.valueS = valueS;
	}


}
