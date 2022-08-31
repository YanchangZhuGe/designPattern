package designPattern.behavior.iterator.enums;

/**
 * <p>Title: UserPermissionTypeEnum.java</p>
 *
 * <p>Description: 数据权限类型</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wangshenglang
 * @since：2018-10-20 上午10:43:06
 */
public enum UserPermissionTypeEnum {
    //由账户权限确定，目前只有经办，审批，查询权限需要控制，后续可根据业务进行扩展

    ACT(1, "经办", "perTypeAct"),
    FLOW(2, "审批", "perTypeFlow"),
    SEL(3, "查询", "perTypeSel");

    private String name;
    private Integer code;
    private String description;

    private UserPermissionTypeEnum(Integer code, String description, String name) {
        this.name = name;
        this.code = code;
        this.description = description;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public Integer getCode() {
        return code;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
