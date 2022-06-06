package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 统借统贷融资合同表
 * </p>
 *
 * @author wyc
 * @since 2022-05-24
 */
@TableName("LMS_GDEBIT_CONTRACT")
public class LmsGdebitContractDO {

    /**
     * 主键ID
     */
    private BigDecimal umId;

    /**
     * 工单ID
     */
    private BigDecimal fmid;

    /**
     * 合同编号
     */
    private String contractNo;

    /**
     * 合同ID
     */
    private BigDecimal contractId;

    /**
     * 融资合同编号
     */
    private String gdtContractNo;

    /**
     * 融资业务品种
     */
    private String gdtBussVariety;

    /**
     * 融资币种
     */
    private String gdtCurrency;

    /**
     * 融资合同金额
     */
    private BigDecimal gdtAmount;

    /**
     * 融资利率
     */
    private BigDecimal gdtRate;

    /**
     * 融资合同开始日
     */
    private LocalDateTime gdtStartDate;

    /**
     * 融资合同结束日
     */
    private LocalDateTime gdtEndDate;

    /**
     * 借款占用金额
     */
    private BigDecimal lmsAmount;

    /**
     * 占用分类 1：选定外部融资合同   2：置换外部融资系统
     */
    private BigDecimal lmsEmployType;

    /**
     * 占用原因
     */
    private String lmsEmployReason;

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

    public BigDecimal getUmId() {
        return umId;
    }

    public void setUmId(BigDecimal umId) {
        this.umId = umId;
    }
    public BigDecimal getFmid() {
        return fmid;
    }

    public void setFmid(BigDecimal fmid) {
        this.fmid = fmid;
    }
    public String getContractNo() {
        return contractNo;
    }

    public void setContractNo(String contractNo) {
        this.contractNo = contractNo;
    }
    public BigDecimal getContractId() {
        return contractId;
    }

    public void setContractId(BigDecimal contractId) {
        this.contractId = contractId;
    }
    public String getGdtContractNo() {
        return gdtContractNo;
    }

    public void setGdtContractNo(String gdtContractNo) {
        this.gdtContractNo = gdtContractNo;
    }
    public String getGdtBussVariety() {
        return gdtBussVariety;
    }

    public void setGdtBussVariety(String gdtBussVariety) {
        this.gdtBussVariety = gdtBussVariety;
    }
    public String getGdtCurrency() {
        return gdtCurrency;
    }

    public void setGdtCurrency(String gdtCurrency) {
        this.gdtCurrency = gdtCurrency;
    }
    public BigDecimal getGdtAmount() {
        return gdtAmount;
    }

    public void setGdtAmount(BigDecimal gdtAmount) {
        this.gdtAmount = gdtAmount;
    }
    public BigDecimal getGdtRate() {
        return gdtRate;
    }

    public void setGdtRate(BigDecimal gdtRate) {
        this.gdtRate = gdtRate;
    }
    public LocalDateTime getGdtStartDate() {
        return gdtStartDate;
    }

    public void setGdtStartDate(LocalDateTime gdtStartDate) {
        this.gdtStartDate = gdtStartDate;
    }
    public LocalDateTime getGdtEndDate() {
        return gdtEndDate;
    }

    public void setGdtEndDate(LocalDateTime gdtEndDate) {
        this.gdtEndDate = gdtEndDate;
    }
    public BigDecimal getLmsAmount() {
        return lmsAmount;
    }

    public void setLmsAmount(BigDecimal lmsAmount) {
        this.lmsAmount = lmsAmount;
    }
    public BigDecimal getLmsEmployType() {
        return lmsEmployType;
    }

    public void setLmsEmployType(BigDecimal lmsEmployType) {
        this.lmsEmployType = lmsEmployType;
    }
    public String getLmsEmployReason() {
        return lmsEmployReason;
    }

    public void setLmsEmployReason(String lmsEmployReason) {
        this.lmsEmployReason = lmsEmployReason;
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
        return "LmsGdebitContractDO{" +
            "umId=" + umId +
            ", fmid=" + fmid +
            ", contractNo=" + contractNo +
            ", contractId=" + contractId +
            ", gdtContractNo=" + gdtContractNo +
            ", gdtBussVariety=" + gdtBussVariety +
            ", gdtCurrency=" + gdtCurrency +
            ", gdtAmount=" + gdtAmount +
            ", gdtRate=" + gdtRate +
            ", gdtStartDate=" + gdtStartDate +
            ", gdtEndDate=" + gdtEndDate +
            ", lmsAmount=" + lmsAmount +
            ", lmsEmployType=" + lmsEmployType +
            ", lmsEmployReason=" + lmsEmployReason +
            ", createTime=" + createTime +
            ", creator=" + creator +
            ", creatorName=" + creatorName +
            ", updateTime=" + updateTime +
            ", updater=" + updater +
            ", updaterName=" + updaterName +
        "}";
    }
}
