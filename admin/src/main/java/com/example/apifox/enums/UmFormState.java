package com.example.apifox.enums;

import java.util.Map;
import java.util.TreeMap;

/**
 * <p>Title: </p>
 *
 * <p>Description: 工作流执行标记</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @since：2021-4-14 
 */
public enum UmFormState implements TypeEnum{
    OBSOLETE(-2, "已作废","AIMS_S_Y0011"),
    REJECT(-1, "已驳回","AIMS_S_Y0012"),
    START(0, "已保存","AIMS_S_Y0013"),
    PROCESS(1, "流程中","AIMS_S_L0006"),
    WITHDRAW(-9, "已撤回","AIMS_S_Y0014"),
    END(9, "已通过","AIMS_S_Y0015");

    private Integer value;
    private String name;
    private String languageCode;

    private UmFormState(Integer value, String name, String languageCode) {
        this.value = value;
        this.name = name;
        this.languageCode = languageCode;
    }

    /**
     * 根据状态编码获取状态名称
     * @param stateValue
     * @return
     */
    public static String getStateName(Integer stateValue) {
        if (stateValue == null) {
            return null;
        }

        for (UmFormState state : values()) {
            if (state.getValue().equals(stateValue)) {
                return state.getName();
            }
        }

        //遍历完都没获取到name的情况下，是stateValue有误，返回null
        return null;
    }

    /**
     * 根据值获取对应的执行记录标记
     *
     * @param value
     * @return
     * @Description:
     */
    public static UmFormState get(Integer value) {
        for (UmFormState ackFlag : values()) {
            if (ackFlag.getValue().equals(value)) {
                return ackFlag;
            }
        }
        return null;
    }

    /**
     * 判断工单状态是否为暂存状态(可修改|提交)
     *
     * @param umState 当前工单状态
     * @return true-暂存 false-非暂存
     */
    public static boolean isTemporaryState(Integer umState) {
        if (umState == null) {
            return true;
        }
        return UmFormState.START.getValue().equals(umState)
                || UmFormState.REJECT.getValue().equals(umState)
                || UmFormState.WITHDRAW.getValue().equals(umState);
    }

    public static Map<String, UmFormState> toMap() {
        Map<String, UmFormState> map = new TreeMap<>();
        UmFormState[] umFormStates = UmFormState.values();
        for (UmFormState umFormState : umFormStates) {
            map.put(String.valueOf(umFormState.value), umFormState);
        }
        return map;
    }

    public Integer getValue() {
        return value;
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
