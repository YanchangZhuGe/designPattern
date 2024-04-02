package com.example.utils.file.enums;

/**
 * <p>Title: GuaranteeFeeChargeType.java</p>
 *
 * <p>Description: 保费收取天数，对应gwms_fee_charge_type表数据</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wangshenglang
 * 
 * @since：2018-11-23 下午06:56:12
 * 
 */
public enum GuaranteeFeeChargeType implements TypeEnum {
	
	TYPE_01(1, "按照实际天数"),
	TYPE_02(2, "不足一期按照一期");
	
	private Integer value;
	private String name;
	
	private GuaranteeFeeChargeType(Integer value, String name) {
		this.value = value;
		this.name = name;
	}

	public void setValue(Integer value) {
		this.value = value;
	}

	public Integer getValue() {
		return value;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}
}
