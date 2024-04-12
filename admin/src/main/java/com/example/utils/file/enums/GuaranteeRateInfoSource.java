package com.example.utils.file.enums;
/**
 * 保费来源
 * @author Administrator
 *
 */
public enum GuaranteeRateInfoSource {
    //本单位
	SELF(new Integer(0)),
	//上级
	OTHER(new Integer(1));
    
	private Integer value;
	
	private GuaranteeRateInfoSource(Integer value) {
		this.value = value;
	}
	public Integer getValue() {
		return value;
	}

	public void setValue(Integer value) {
		this.value = value;
	}

    
}
