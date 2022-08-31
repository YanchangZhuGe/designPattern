package designPattern.behavior.iterator.enums;

/**
 * <p>Title: UserPermissionBussTypeEnum.java</p>
 *
 * <p>Description: 数据权限业务类型</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wangshenglang
 * @since：2018-10-20 上午10:34:37
 */
public enum UserPermissionBussTypeEnum {
    //对应g_user_per_busstype表，由数据初始化

    ACCOUNT(1, "账户"),
    PTMS(2, "付款"),
    CTMS(3, "收款"),
    GDEBIT(4, "融资"),
    CLMS(5, "授信"),
    GWMS(6, "担保"),
    LGM(7, "保函"),
    LCMS(8, "信用证"),
    CFB(9, "资金计划"),
    BLEND(10, "勾对");

    private String name;
    private Integer code;

    private UserPermissionBussTypeEnum(Integer code, String name) {
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
