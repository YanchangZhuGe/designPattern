package com.example.enums;

import com.nstc.ptms.constants.PtmsConstants;

/**
 * <p>Title: 工作流日志分组枚举</p>
 *
 * <p>Description: 工作流日志分组枚举</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tjg
 * @version 1.0
 * @since：2021/9/8 14:53
 */
public enum FlowGroupEnum {
    /**
     * 申请单
     */
    APPLY,
    /**
     * 指令
     */
    ORDER,
    /**
     * 补填
     */
    REFILL;

    private static final String SERVICE_SUFFIX = "_FLOW_SERVICE";

    public String getBeanName() {
        return new StringBuilder()
                .append(PtmsConstants.CHANNEL)
                .append(".")
                .append(this.name())
                .append(SERVICE_SUFFIX)
                .toString();
    }
}
