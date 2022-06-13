package com.example.enums;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:工作流枚举
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author zhanghonghui
 * @version 1.0
 * @since：2015-9-22 上午11:43:15
 */
public enum LmsBizFlowEnum {
    LMS_FM001("LMS.FLOW.001", "合同登记");


    LmsBizFlowEnum(String key, String name) {
        this.key = key;
        this.name = name;
    }

    private String key;
    private String name;

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
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
