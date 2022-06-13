package com.example.apifox.enums;

/**
 * <p>Title: </p>
 *
 * <p>Description: 工单日志枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author LYY
 * @since：2016-7-21 下午01:18:33
 */

public enum UmLogStep {

    /**
     * 暂存
     */
    SAVE(0, "保存"),
    /**
     * 提交
     */
    SUBMIT(1, "提交"),
    /**
     * 通过
     */
    END(9, "通过"),
    /**
     * 驳回
     */
    REJECT(-1, "驳回"),
    /**
     * 撤销
     */
    CANCLE(-9, "撤销");


    private Integer value;
    private String name;

    private UmLogStep(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    public static UmLogStep get(Integer value) {
        switch (value) {
            case 0:
                return SAVE;
            case 1:
                return SUBMIT;
            case 9:
                return END;
            case -1:
                return REJECT;
        }
        return null;
    }

    /**
     * @param value
     * @Description:取步骤名称
     * @author LYY
     * @since 2016-7-21 下午01:18:33
     */
    public static String getStepName(Integer value) {
        for (UmLogStep s : values()) {
            if (s.getValue().equals(value)) {
                return s.getName();
            }
        }
        return "";
    }


    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
