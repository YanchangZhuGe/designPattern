package com.example.enums;

import com.nstc.ptms.validate.EnumValueLister;

public enum RelateOrderTypeEnum implements EnumValueLister {
    AUTO("AUTO", "自动匹配"),
    HAND("HAND", "手动匹配");

    public static String getNameByNo(String typeNo) {
        for (RelateOrderTypeEnum type : values()) {
            if (type.typeNo.equals(typeNo)) {
                return type.typeName;
            }
        }
        return "";
    }

    /**
     * 补填状态编号
     */
    private final String typeNo;
    /**
     * 补填状态名称
     */
    private final String typeName;

    RelateOrderTypeEnum(String typeNo, String typeName) {
        this.typeNo = typeNo;
        this.typeName = typeName;
    }

    public String getTypeNo() {
        return typeNo;
    }

    public String getTypeName() {
        return typeName;
    }

    public static String[] exhaustiveList() {
        return new String[]{HAND.typeNo, AUTO.typeNo, null};
    }
}
