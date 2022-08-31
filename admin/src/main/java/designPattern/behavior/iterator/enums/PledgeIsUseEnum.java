/*================================================================================
 * DumpType.java
 * 生成日期：2015-9-25 上午11:05:14
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
 * Description:抵质押物是否被使用
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author hsw
 * @version 1.0
 * @since：2018-2-7 上午11:05:14
 */
public enum PledgeIsUseEnum {
    /**
     * 未使用
     */
    NOUSE(new Integer(0), "否"),
    /**
     * 使用
     */
    USE(new Integer(1), "是");
    private Integer value;
    private String name;

    PledgeIsUseEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    /**
     * @param value
     * @return
     * @Description:
     * @author hsw
     * @since 2015-9-22 上午11:05:10
     */
    public static String getTypeName(Integer value) {
        for (PledgeIsUseEnum t : values()) {
            if (t.getValue().equals(value)) {
                return t.getName();
            }
        }
        return "";
    }

    /**
     * @return String
     */
    public Integer getValue() {
        return value;
    }

    /**
     * @param value String
     */
    public void setValue(Integer value) {
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
