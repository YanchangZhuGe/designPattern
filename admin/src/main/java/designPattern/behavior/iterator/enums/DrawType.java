/*================================================================================
 * DrawType.java
 * 生成日期：2015-9-22 下午01:51:37
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
 * Description:支取方式
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author zhanghonghui
 * @version 1.0
 * @since：2015-9-22 下午01:51:37
 */
public enum DrawType implements TypeEnum {
    /**
     * 到期支取
     */
    T_01("01", "到期支取"),
    /**
     * 本金转存
     */
    T_02("02", "本金转存"),
    /**
     * 本息转存
     */
    T_03("03", "本息转存"),
    /**
     * 抵扣本息
     */
    T_04("04", "抵扣本息");
    private String value;
    private String name;

    DrawType(String value, String name) {
        this.value = value;
        this.name = name;
    }

    public static String getTypeName(String value) {
        for (DrawType p : values()) {
            if (p.getValue().equals(value)) {
                return p.getName();
            }
        }
        return "";
    }

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
