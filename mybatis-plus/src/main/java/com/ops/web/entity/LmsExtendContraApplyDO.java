package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 展期申请表
 * </p>
 *
 * @author wyc
 * @since 2022-05-13
 */
@TableName("LMS_EXTEND_CONTRA_APPLY")
public class LmsExtendContraApplyDO {

    /**
     * 台账ID
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
     * 是否已做展期登记 0：否；1：是
     */
    private BigDecimal isExtendContract;

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

    public BigDecimal getApplyId() {
        return applyId;
    }

    public void setApplyId(BigDecimal applyId) {
        this.applyId = applyId;
    }
    public BigDecimal getContractId() {
        return contractId;
    }

    public void setContractId(BigDecimal contractId) {
        this.contractId = contractId;
    }
    public BigDecimal getIsDevelop() {
        return isDevelop;
    }

    public void setIsDevelop(BigDecimal isDevelop) {
        this.isDevelop = isDevelop;
    }
    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
    public LocalDateTime getExtendDate() {
        return extendDate;
    }

    public void setExtendDate(LocalDateTime extendDate) {
        this.extendDate = extendDate;
    }
    public BigDecimal getIsExtendContract() {
        return isExtendContract;
    }

    public void setIsExtendContract(BigDecimal isExtendContract) {
        this.isExtendContract = isExtendContract;
    }
    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }
    public String getCreatorName() {
        return creatorName;
    }

    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }
    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }
    public String getUpdater() {
        return updater;
    }

    public void setUpdater(String updater) {
        this.updater = updater;
    }
    public String getUpdaterName() {
        return updaterName;
    }

    public void setUpdaterName(String updaterName) {
        this.updaterName = updaterName;
    }

    @Override
    public String toString() {
        return "LmsExtendContraApplyDO{" +
            "applyId=" + applyId +
            ", contractId=" + contractId +
            ", isDevelop=" + isDevelop +
            ", remark=" + remark +
            ", extendDate=" + extendDate +
            ", isExtendContract=" + isExtendContract +
            ", createTime=" + createTime +
            ", creator=" + creator +
            ", creatorName=" + creatorName +
            ", updateTime=" + updateTime +
            ", updater=" + updater +
            ", updaterName=" + updaterName +
        "}";
    }
}
