package designPattern.behavior.iterator.enums;

/**
 * <p>Title:工单类型</p>
 *
 * <p>Description:工单类型</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @since：2021/4/14 11:37
 */
public enum UmFmClsEnum {

    /***担保申请**/
    GWMS_FM001("1", "GWMS_FM001", "担保申请"),
    /***担保登记**/
    GWMS_FM002("2", "GWMS_FM002", "担保合同登记"),
    /***担保合同变更**/
    GWMS_FM003("3", "GWMS_FM003", "担保合同变更"),
    GWMS_FM006("6", "GWMS_FM006", "担保额度占用"),
    GWMS_FM007("7", "GWMS_FM007", "担保占用变更"),
//    /***开户登记**/
//    AIMS_FM003("3", "AIMS_FM003", "开户登记"),
//    /***账户基本信息变更**/
//    AIMS_FM004("4", "AIMS_FM004", "账户变更"),
//
//    AIMS_FM007("7", "AIMS_FM007", "销户登记"),
//    /***取消销户登记**/
//    AIMS_FM008("8", "AIMS_FM008", "取消销户登记"),
//    /***非直连明细导入**/
//    AIMS_FM009("9", "AIMS_FM009", "非直连明细导入"),
//    /***收支信息 不属于工作流**/
//    AIMS_FM010("10","AIMS_FM010", "收支信息"),
//    /***初始化余额  不属于工作流 **/
//    AIMS_FM011("11","AIMS_FM011", "初始化余额"),
//    /***资金冻结  不属于工作流 **/
//    AIMS_FM012("12","AIMS_FM012", "资金冻结"),
    /***押品登记**/
    GWMS_FM013("13", "GWMS_FM013", "押品登记"),
    GWMS_FM014("14", "GWMS_FM014", "担保替换"),
    GWMS_FM015("15", "GWMS_FM015", "担保占用释放"),
    GWMS_FM016("16", "GWMS_FM016", "担保合同修正"),
    GWMS_FM017("17", "GWMS_FM017", "担保合同删除"),
    GWMS_FM018("18", "GWMS_FM018", "押品导入"),
    ;

    private String code;
    private String value;
    private String name;

    UmFmClsEnum(String code, String value, String name) {
        this.code = code;
        this.value = value;
        this.name = name;
    }

    @Override
    public String toString() {
        return value + ":" + name;
    }

    /**
     * @param value
     * @return String
     * @Description：根据VALUE获取NAME
     * @author tangjiagang
     * @since：2020/10/28 16:37
     */
    public static String getFmClsName(String value) {
        for (UmFmClsEnum anEnum : values()) {
            if (anEnum.getValue().equals(value)) {
                return anEnum.getName();
            }
        }
        return "";
    }

    /**
     * @param value
     * @return
     * @Description：获取工单类型
     * @author tangjiagang
     * @since：2020/10/28 11:36
     */
    public static UmFmClsEnum getFmCls(String value) {
        for (UmFmClsEnum anEnum : values()) {
            if (anEnum.getValue().equals(value)) {
                return anEnum;
            }
        }
        return null;
    }


    /**
     * @param code
     * @return
     * @Description：获取工单类型
     * @author tangjiagang
     * @since：2020/10/28 11:36
     */
    public static UmFmClsEnum getFmClsByCode(String code) {
        for (UmFmClsEnum anEnum : values()) {
            if (anEnum.getCode().equals(code)) {
                return anEnum;
            }
        }
        return null;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
