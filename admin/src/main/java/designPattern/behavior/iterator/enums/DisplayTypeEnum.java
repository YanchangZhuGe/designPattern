package designPattern.behavior.iterator.enums;

/**
 * <p>Title：</p>
 *
 * <p>Description： 内部评测项目设置，显示方式枚举</p>
 *
 * <p>Company：北京九恒星科技股份有限公司</p>
 *
 * @author xiongyong
 * @since：2018年2月12日 上午10:52:15
 */
public enum DisplayTypeEnum implements TypeEnum {

    SUMMARIZED_ITEM(0, "汇总项"),
    DIVIDE_ITEM(1, "打分项");

    private Integer value;
    private String name;

    public Integer getValue() {
        return value;
    }

    private DisplayTypeEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
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
