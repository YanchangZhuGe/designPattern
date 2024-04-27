package com.example.utils.file.enums;

/**
 * 担保合同登记是否需要申请
 */
public enum GwmsNeedApplyFlagEnum implements TypeEnum {

	APPLY_NO_NEEDED("0", "不开启"),

    APPLY_CAN_NEEDED("1", "开启但弱控"),

    APPLY_MUST_NEEDED("2", "开启且强控");

    private String value;
    private String name;

    GwmsNeedApplyFlagEnum(String value,String name){
        this.value = value;
        this.name = name;
    }

    @Override
    public Object getValue() {
        return value;
    }

    @Override
    public String getName() {
        return name;
    }
}
