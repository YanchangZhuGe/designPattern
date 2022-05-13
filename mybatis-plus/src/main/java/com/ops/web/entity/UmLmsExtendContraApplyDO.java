package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 展期申请工单表
 * </p>
 *
 * @author wyc
 * @since 2022-05-12
 */
@TableName("UM_LMS_EXTEND_CONTRA_APPLY")
public class UmLmsExtendContraApplyDO {

    /**
     * 工单ID
     */
    private BigDecimal fmid;

    /**
     * 展期申请ID
     */
    private BigDecimal applyId;

    /**
     * 合同id
     */
    private BigDecimal contractId;

    /**
     * 是否线下开展决策会议  0：否；1：是
     */
    private BigDecimal isDevelop;

    /**
     * 备注
     */
    private String remark;

    /**
     * 展期截止日期
     */
    private LocalDateTime extendDate;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 创建人登录名
     */
    private String creator;

    /**
     * 创建人登录名称
     */
    private String creatorName;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;

    /**
     * 更新操作人登录名
     */
    private String updater;

    /**
     * 更新操作人登录名称
     */
    private String updaterName;

}
