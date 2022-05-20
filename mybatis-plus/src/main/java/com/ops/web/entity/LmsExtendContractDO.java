package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 展期合同登记表
 * </p>
 *
 * @author wyc
 * @since 2022-05-18
 */
@TableName("LMS_EXTEND_CONTRACT")
public class LmsExtendContractDO {

    /**
     * 流水号
     */
    @TableField("CHANGE_ID")
    private BigDecimal changeId;

    /**
     * 展期申请ID
     */
    @TableField("APPLY_ID")
    private BigDecimal applyId;

    /**
     * 合同id
     */
    @TableField("CONTRACT_ID")
    private BigDecimal contractId;

    /**
     * 备注
     */
    @TableField("REMARK")
    private String remark;

    /**
     * 展期截止日期
     */
    @TableField("EXTEND_DATE")
    private LocalDateTime extendDate;

    /**
     * 展期利率
     */
    @TableField("RATE")
    private BigDecimal rate;

    /**
     * 展期金额
     */
    @TableField("EXTEND_AMOUNT")
    private BigDecimal extendAmount;

    /**
     * 展期合同编号
     */
    @TableField("EXTEND_CONTRACT_NO")
    private String extendContractNo;

    /**
     * 创建时间
     */
    @TableField("CREATE_TIME")
    private LocalDateTime createTime;

    /**
     * 创建人登录名
     */
    @TableField("CREATOR")
    private String creator;

    /**
     * 创建人登录名称
     */
    @TableField("CREATOR_NAME")
    private String creatorName;

    /**
     * 更新时间
     */
    @TableField("UPDATE_TIME")
    private LocalDateTime updateTime;

    /**
     * 更新操作人登录名
     */
    @TableField("UPDATER")
    private String updater;

    /**
     * 更新操作人登录名称
     */
    @TableField("UPDATER_NAME")
    private String updaterName;

}
