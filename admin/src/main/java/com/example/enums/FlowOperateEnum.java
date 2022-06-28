package com.example.enums;

import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

/**
 * <p>Title: 工作流操作枚举</p>
 *
 * <p>Description: 工作流操作枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/8 15:07
 */
@Getter
public enum FlowOperateEnum {

    /**
     * 保存
     */
    SAVED(0, "保存"),
    /**
     * 提交
     */
    SUBMIT(1, "提交"),
    /**
     * 复核
     */
    REVIEW(2, "复核"),
    /**
     * 审批通过
     */
    APPROVAL(3, "审批通过"),
    /**
     * 驳回
     */
    REJECT(-1, "驳回"),
    /**
     * 废弃
     */
    OBSOLETE(-2, "废弃"),
    ;

    private final Integer state;
    private final String name;

    FlowOperateEnum(Integer state, String name) {
        this.state = state;
        this.name = name;
    }

    public static String getNameByState(Integer state) {
        for (FlowOperateEnum flowOperateEnum : FlowOperateEnum.values()) {
            if (flowOperateEnum.state.equals(state)) {
                return flowOperateEnum.getName();
            }
        }
        return "";
    }

    /**
     * 待付款安排列表查询状态
     */
    public static List<Integer> getPayArrangementFlowOperate() {
        List<Integer> flowStateList = new ArrayList<>(2);
        flowStateList.add(SAVED.state);
        flowStateList.add(REJECT.state);
        return flowStateList;
    }

    public static boolean isArrangement(Integer state) {
        return SAVED.state.equals(state) || REJECT.state.equals(state);
    }
}
