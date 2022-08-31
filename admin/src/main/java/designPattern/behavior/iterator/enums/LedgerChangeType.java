/*================================================================================
 * LedgerChangeType.java
 * 生成日期：2015-10-20 下午02:42:11
 * 作          者：zhanghonghui
 * 项          目：GWMS-Service
 * (C)COPYRIGHT BY NSTC.
 * ================================================================================
 */
package designPattern.behavior.iterator.enums;

/**
 * <p>
 * Title:
 * </p>
 *
 * <p>
 * Description:担保额度变更方式
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author zhanghonghui
 * @version 1.0
 * @since：2015-10-20 下午02:42:11
 */
public enum LedgerChangeType {
    T_00("00", "额度占用"),

    /**
     * 追加占用
     */
    T_01("01", "追加占用"),
    /**
     * 释放额度
     */
    T_02("02", "释放额度"),
    /**
     * 全额释放
     */
    T_03("03", "全额释放"),
    /**
     * 追减占用
     */
    T_04("04", "追减占用");

    LedgerChangeType(String value, String name) {
        this.value = value;
        this.name = name;
    }

    public static String getTypeName(String state) {
        for (LedgerChangeType s : values()) {
            if (s.getValue().equals(state)) {
                return s.getName();
            }
        }
        return null;
    }


    private String value;
    private String name;

    /**
     * @return String
     */
    public String getValue() {
        return value;
    }

    /**
     * @param value String
     */
    public void setValue(String value) {
        this.value = value;
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
