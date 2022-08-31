package designPattern.behavior.iterator.enums;

/**
 * <p>Title: UserPermissionOpenFlagEnum.java</p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wangshenglang
 * @since：2018-10-20 上午10:50:22
 */
public enum UserPermissionOpenFlagEnum {

    OPEN(1, "开启数据权限"),
    CLOSE(null, "关闭数据权限");

    private String name;
    private Integer code;

    private UserPermissionOpenFlagEnum(Integer code, String name) {
        this.name = name;
        this.code = code;
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
}
