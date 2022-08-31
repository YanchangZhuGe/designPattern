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
 * Description:抵质押类型
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author zhanghonghui
 * @version 1.0
 * @since：2015-9-25 上午11:05:14
 */
public enum PledgeTypeEnum implements TypeEnum {
    /**
     * 抵押 1
     */
    MORTGAGE(new Integer(1), "抵押"),
    /**
     * 质押 2
     */
    PLEDGE(new Integer(2), "质押");
    private Integer value;
    private String name;

    PledgeTypeEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    /**
     * @param value
     * @return
     * @Description:
     * @author zhanghonghui
     * @since 2015-9-22 上午11:05:10
     */
    public static String getTypeName(Integer value) {
        for (PledgeTypeEnum t : values()) {
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
