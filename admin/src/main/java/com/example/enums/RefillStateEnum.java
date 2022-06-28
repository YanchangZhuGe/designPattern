package com.example.enums;

import com.nstc.ptms.model.ArrayWrapper;

public enum RefillStateEnum {
    UN_REFILL("UN_REFILL", "待补填", null, new ArrayWrapper<>("SAVED")),
    AUTO_CONFIRMING("AUTO_CONFIRMING", "自动补填待确认", new ArrayWrapper<>("SAVED"), null),
    SAVED("SAVED", "补填已保存", new ArrayWrapper<>("PROCESSING", "ABANDONED"), new ArrayWrapper<>("UN_REFILL", "SAVED")),
    REJECTED("REJECTED", "补填已驳回", new ArrayWrapper<>("ABANDONED", "SAVED"), new ArrayWrapper<>("PROCESSING")),
    PROCESSING("PROCESSING", "审核中", new ArrayWrapper<>("EFFECTIVE"), new ArrayWrapper<>("REJECTED")),
    EFFECTIVE("EFFECTIVE", "已完成", new ArrayWrapper<>("SAVED"), null),
    ABANDONED("ABANDONED", "废弃", null, null);
    /**
     * 待处理
     */
    public static final String UN_EFFECTIVE = "unEffective";
    /**
     * 全部
     */
    public static final String ALL = "all";

    /**
     * 根据明细状态查询付款明细
     *
     * @param detailStatus 明细状态
     * @return 查询补填状态数据
     */
    public static String[] getRefillStateNosByDetailStatus(String detailStatus) {
        String[] refillStates;
        if (UN_EFFECTIVE.equals(detailStatus)) {
            refillStates = new String[]{
                    UN_REFILL.stateNo,
                    AUTO_CONFIRMING.stateNo,
                    SAVED.stateNo,
                    REJECTED.stateNo
            };
        } else {
            refillStates = null;
        }
        return refillStates;
    }

    /**
     * 校验状态流转是否正确
     *
     * @param preState 前置状态
     * @param newState 即将流转状态
     * @return true-可以流转 false-状态流转不正确
     */
    public static boolean validateStateFlow(RefillStateEnum preState, RefillStateEnum newState) {
        if (preState == null || newState == null) {
            return false;
        }
        ArrayWrapper<String> nextStateNos = preState.nextStateNos;
        if (nextStateNos != null && nextStateNos.contains(newState.stateNo)) {
            return true;
        }

        ArrayWrapper<String> switchStateNos = preState.switchStateNos;
        if (switchStateNos != null && switchStateNos.contains(newState.stateNo)) {
            return true;
        }

        return false;
    }

    /**
     * 根据补填状态编号获取补填状态
     *
     * @param stateNo
     * @return
     */
    public static RefillStateEnum getStateByNo(String stateNo) {
        for (RefillStateEnum state : values()) {
            if (state.stateNo.equals(stateNo)) {
                return state;
            }
        }
        return null;
    }

    /**
     * 根据补填状态编号查询名称
     *
     * @param stateNo 补填状态编号
     * @return 补填状态名称
     */
    public static String getNameByNo(String stateNo) {
        RefillStateEnum state = getStateByNo(stateNo);
        if (state == null) {
            return "";
        } else {
            return state.stateName;
        }
    }

    /**
     * 补填状态编号
     */
    private String stateNo;
    /**
     * 补填状态名称
     */
    private String stateName;

    private ArrayWrapper<String> nextStateNos;
    private ArrayWrapper<String> switchStateNos;

    RefillStateEnum(String stateNo, String stateName, ArrayWrapper<String> nextStateNos, ArrayWrapper<String> switchStateNos) {
        this.stateNo = stateNo;
        this.stateName = stateName;
        this.nextStateNos = nextStateNos;
        this.switchStateNos = switchStateNos;
    }

    public String getStateNo() {
        return stateNo;
    }

    public String getStateName() {
        return stateName;
    }
}
