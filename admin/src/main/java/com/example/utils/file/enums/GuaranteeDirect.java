package com.example.utils.file.enums;

/**
 * 担保方向枚举
 *
 * @author Administrator
 */
public enum GuaranteeDirect {
    /**
     * 提供担保
     */
    PRO_GUAR(0),

    /**
     * 获得担保
     */
    GET_GUAR(1);

    private Integer value;

    /**
     * 根据担保方向编码获得担保方向名称
     *
     * @param tempValue
     * @return
     */
    public static String getGuaranteeDirName(Integer tempValue) {
        if (tempValue == null) {
            return null;
        }

        if (PRO_GUAR.getValue().equals(tempValue)) {
            return "提供担保";
        } else if (GET_GUAR.getValue().equals(tempValue)) {
            return "获得担保";
        }

        return null;
    }

    private GuaranteeDirect(Integer value) {
        this.value = value;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }

}
