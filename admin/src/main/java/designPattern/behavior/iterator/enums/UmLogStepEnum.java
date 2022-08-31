package designPattern.behavior.iterator.enums;

/**
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author jipengfei
 * @since：2015-10-16 上午09:50:49
 */
public enum UmLogStepEnum {
    /**
     * 保存
     */
    SAVE(new Integer(0), "保存"),
    /**
     * 提交
     */
    SUBMIT(new Integer(1), "提交"),
    /**
     * 审批通过
     */
    PASS(new Integer(2), "审批通过"),
    /**
     * 审批驳回
     */
    REJECT(new Integer(3), "审批驳回"),
    /**
     * 审批生效
     */
    EFFECT(new Integer(4), "审批生效");

    private Integer value;
    private String name;

    private UmLogStepEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
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

    /**
     * @param value
     * @return
     * @Description:取步骤名称
     * @author zhanghonghui
     * @since 2015-9-28 下午03:19:28
     */
    public static String getStepName(Integer value) {
        for (UmLogStepEnum s : values()) {
            if (s.getValue().equals(value)) {
                return s.getName();
            }
        }
        return "";
    }

}
