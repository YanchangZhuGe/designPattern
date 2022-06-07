package com.example.enums;

/**
 * 
 * <p>
 * Title:记账类型
 * </p>
 * 
 * <p>
 * Description:
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author 杨庆祥
 * 
 * @since：2013-4-10 上午09:31:48
 * 
 * @version 1.0
 */
public enum KeepTypeEnum {

    /** 放款 */
    KT_INCREASE("KT_INCREASE", "放款"),
    /** 本息还款 */
    KT_DECREASE_WITH_INTR("KT_DECREASE_WITH_INTR", "本息还款"),
    /** 本金还款 */
    KT_DECREASE_WITHOUT_INTR(
            "KT_DECREASE_WITHOUT_INTR", "本金还款"),
    /** 提前本息还款 */
    KT_DECREASE_BF_WITH_INTR(
            "KT_DECREASE_BF_WITH_INTR", "提前本息还款"),
    /** 提前本金还款 */
    KT_DECREASE_BF_WITHOUT_INTR(
            "KT_DECREASE_BF_WITHOUT_INTR", "提前本金还款");

    private String code;

    private String text;

    KeepTypeEnum(String code, String text) {
        this.code =  code;
        this.text = text;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}
