package designPattern.behavior.iterator.enums;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>Title: DropDownValue.java</p>
 *
 * <p>Description:  账户下拉值</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 */
public enum DropDownValue {
    /**
     * 发生额类型
     */
    AccrualType("AccrualType", AccrualType.class),

    /**
     * 担保合同台账类型
     */
    BussLedgerType("BussLedgerType", BussLedgerType.class),

    /**
     * 反担保类型枚举
     */
    CounterTypeEnum("CounterTypeEnum", CounterTypeEnum.class),

    /**
     * CrossBorderEnum
     */
    CrossBorderEnum("CrossBorderEnum", CrossBorderEnum.class),

    /**
     * 内部评测项目设置，显示方式枚举
     */
    DisplayTypeEnum("DisplayTypeEnum", DisplayTypeEnum.class),

    /**
     * 支取方式
     */
    DrawType("DrawType", DrawType.class),

    /**
     * 转存方式
     */
    DumpType("DumpType", DumpType.class),

    /**
     * 保费缴纳状态
     */
    FeeStateEnum("FeeStateEnum", FeeStateEnum.class),

    /**
     * 免收操作
     */
    FreeOperationEnum("FreeOperationEnum", FreeOperationEnum.class),

    /**
     * 保费收取频率
     */
    FrequencyType("FrequencyType", FrequencyType.class),

    /**
     * 生效/不生效
     */
    GuaranteeBaseRateStateType("GuaranteeBaseRateStateType", GuaranteeBaseRateStateType.class),

    /**
     * 质押/抵押/保证
     */
    GuaranteeCounterEnum("GuaranteeCounterEnum", GuaranteeCounterEnum.class),

    /**
     * 保费收取天数
     */
    GuaranteeFeeChargeType("GuaranteeFeeChargeType", GuaranteeFeeChargeType.class),

    /**
     * 担保合同性质
     */
    GuaranteeNatureEnum("GuaranteeNatureEnum", GuaranteeNatureEnum.class),

    /**
     * 担保费率浮动方式
     */
    GuaranteeRateFloatType("GuaranteeRateFloatType", GuaranteeRateFloatType.class),

    /**
     * 保费费率下级是否适用
     */
    GuaranteeRateMange("GuaranteeRateMange", GuaranteeRateMange.class),

    /**
     * 担保合同状态
     */
    GuaranteeState("GuaranteeState", GuaranteeState.class),

    /**
     * 附件类型
     */
    GWMSFileType("GWMSFileType", GWMSFileType.class),

    /** 抵质押物类型编码*/
    // PledgeTypeCode("PledgeTypeCode",PledgeTypeCode.class),

    /**
     * 抵质押类型
     */
    PledgeTypeEnum("PledgeTypeEnum", PledgeTypeEnum.class),

    /**
     * 保证金存款性质
     */
    PropEnum("PropEnum", PropEnum.class),

    /**
     * 集团内,集团外
     */
    IsCheckEnum("IsCheckEnum", IsCheckEnum.class),

    /**
     * 担保方式
     */
    GuaranteeType("GuaranteeType", GuaranteeType.class),

    /**
     * 在押/待押 押品状态
     */
    PledgeStateEnum("PledgeStateEnum", PledgeStateEnum.class);;

    private String key;
    private Class<?> name;

    public TypeEnum[] getValues() {
        return values;
    }

    TypeEnum[] values;

    DropDownValue(String key, Class<? extends TypeEnum> kind) {
        this.key = key;
        this.values = kind.getEnumConstants();
    }

    public static List<Map<String, Object>> getNameByKey(String key) {
        List<Map<String, Object>> result = new ArrayList<>();
        for (DropDownValue dropDownValue : DropDownValue.values()) {
            if (dropDownValue.getKey().equalsIgnoreCase(key)) {
                for (TypeEnum t : dropDownValue.values) {
                    Map<String, Object> map = new HashMap<>();

                    map.put("value", t.getValue());
                    map.put("label", t.getName());

                    result.add(map);
                }
            }

        }
        return result;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public Class<?> getName() {
        return name;
    }

    public void setName(Class<?> name) {
        this.name = name;
    }


    public class Tuple<M, T> {
        private final M m;
        private final T t;

        public Tuple(M m, T t) {
            this.m = m;
            this.t = t;
        }

        public M getM() {
            return m;
        }

        public T getT() {
            return t;
        }
    }
}
