package com.example.utils.file.enums;


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
 *
 */
public enum DropDownValue {
    /** 发生额类型*/
    AccrualType("AccrualType", com.example.utils.file.enums.AccrualType.class),

    /** 担保合同台账类型*/
    BussLedgerType("BussLedgerType", com.example.utils.file.enums.BussLedgerType.class),

    /** 反担保类型枚举*/
    CounterTypeEnum("CounterTypeEnum", com.example.utils.file.enums.CounterTypeEnum.class),

    /** CrossBorderEnum*/
    CrossBorderEnum("CrossBorderEnum", com.example.utils.file.enums.CrossBorderEnum.class),

    /** 内部评测项目设置，显示方式枚举*/
    DisplayTypeEnum("DisplayTypeEnum", com.example.utils.file.enums.DisplayTypeEnum.class),

    /** 支取方式*/
    DrawType("DrawType", com.example.utils.file.enums.DrawType.class),

    /** 转存方式*/
    DumpType("DumpType",DumpType.class),

    /** 保费缴纳状态*/
    FeeStateEnum("FeeStateEnum",FeeStateEnum.class),

    /** 免收操作*/
    FreeOperationEnum("FreeOperationEnum",FreeOperationEnum.class),

    /** 保费收取频率*/
    FrequencyType("FrequencyType", com.example.utils.file.enums.FrequencyType.class),

    /** 生效/不生效*/
    GuaranteeBaseRateStateType("GuaranteeBaseRateStateType",GuaranteeBaseRateStateType.class),

    /** 质押/抵押/保证 */
    GuaranteeCounterEnum("GuaranteeCounterEnum", com.example.utils.file.enums.GuaranteeCounterEnum.class),

    /** 保费收取天数*/
    GuaranteeFeeChargeType("GuaranteeFeeChargeType", com.example.utils.file.enums.GuaranteeFeeChargeType.class),

    /** 担保合同性质*/
    GuaranteeNatureEnum("GuaranteeNatureEnum", com.example.utils.file.enums.GuaranteeNatureEnum.class),

    /** 担保费率浮动方式*/
    GuaranteeRateFloatType("GuaranteeRateFloatType",GuaranteeRateFloatType.class),

    /** 保费费率下级是否适用*/
    GuaranteeRateMange("GuaranteeRateMange", com.example.utils.file.enums.GuaranteeRateMange.class),

    /** 担保合同状态*/
    GuaranteeState("GuaranteeState", com.example.utils.file.enums.GuaranteeState.class),

    /** 附件类型*/
    GWMSFileType("GWMSFileType",GWMSFileType.class),

    /** 抵质押物类型编码*/
   // PledgeTypeCode("PledgeTypeCode",PledgeTypeCode.class),

    /** 抵质押类型*/
    PledgeTypeEnum("PledgeTypeEnum",PledgeTypeEnum.class),

    /** 保证金存款性质*/
    PropEnum("PropEnum", com.example.utils.file.enums.PropEnum.class),

    /** 集团内,集团外 */
    IsCheckEnum("IsCheckEnum",IsCheckEnum.class),

    /** 担保方式 */
    GuaranteeType("GuaranteeType", com.example.utils.file.enums.GuaranteeType.class),

    /** 在押/待押 押品状态*/
    PledgeStateEnum("PledgeStateEnum", com.example.utils.file.enums.PledgeStateEnum.class);
    ;

    private String key;
    private Class<?> name;

    public TypeEnum[] getValues(){
        return values;
    }

    TypeEnum[] values;

    DropDownValue(String key, Class<? extends TypeEnum> kind) {
        this.key=key;
        this.values=kind.getEnumConstants();
    }

    public static List<Map<String,Object>> getNameByKey(String key){
        List<Map<String,Object>> result=new ArrayList<>();
        for(DropDownValue dropDownValue: DropDownValue.values()){
            if(dropDownValue.getKey().equalsIgnoreCase(key)){
                for(TypeEnum t:dropDownValue.values){
                    Map<String,Object> map=new HashMap<>();

                    map.put("value",t.getValue());
                    map.put("label",t.getName());

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


    public class Tuple<M,T> {
        private final M m;
        private final T t;
        public Tuple(M m, T t){
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
