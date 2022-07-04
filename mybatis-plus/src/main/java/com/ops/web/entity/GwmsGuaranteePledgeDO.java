package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 担保合同押品信息表
 * </p>
 *
 * @author wyc
 * @since 2022-07-04
 */
@TableName("GWMS_GUARANTEE_PLEDGE")
public class GwmsGuaranteePledgeDO {

    /**
     * PID
     */
    private BigDecimal id;

    /**
     * 担保合同ID
     */
    private BigDecimal guaranteeId;

    /**
     * 抵质押物类型
     */
    private String ptCode;

    /**
     * 抵（质）押物品ID
     */
    private BigDecimal pledgeId;

    /**
     * 抵（质）押编号
     */
    private String pledgeNo;

    /**
     * 评估价值
     */
    private BigDecimal evalAmount;

    /**
     * 抵（质）押价值
     */
    private BigDecimal amount;

    /**
     * 是否被使用 0：未使用 1：使用
     */
    private BigDecimal useFlag;

    /**
     * 质押比例
     */
    private BigDecimal pledgeRatio;

    /**
     * 业务品种名称
     */
    private String bizTypeName;

    /**
     * 开始日
     */
    private LocalDateTime startDate;

    /**
     * 到期日
     */
    private LocalDateTime endDate;

    /**
     * 集团内/集团外
     */
    private String isCheck;

    /**
     * 反担保类型 0,质押; 1, 抵押; 2,保证;
     */
    private String guaranteeType;

    /**
     * 出质人/抵押人/保证人
     */
    private String pledgor;

    /**
     * 抵质押/保证金额
     */
    private BigDecimal pledgeAmount;

    /**
     * 净值
     */
    private BigDecimal netWorthAmouint;

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getGuaranteeId() {
        return guaranteeId;
    }

    public void setGuaranteeId(BigDecimal guaranteeId) {
        this.guaranteeId = guaranteeId;
    }

    public String getPtCode() {
        return ptCode;
    }

    public void setPtCode(String ptCode) {
        this.ptCode = ptCode;
    }

    public BigDecimal getPledgeId() {
        return pledgeId;
    }

    public void setPledgeId(BigDecimal pledgeId) {
        this.pledgeId = pledgeId;
    }

    public String getPledgeNo() {
        return pledgeNo;
    }

    public void setPledgeNo(String pledgeNo) {
        this.pledgeNo = pledgeNo;
    }

    public BigDecimal getEvalAmount() {
        return evalAmount;
    }

    public void setEvalAmount(BigDecimal evalAmount) {
        this.evalAmount = evalAmount;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public BigDecimal getUseFlag() {
        return useFlag;
    }

    public void setUseFlag(BigDecimal useFlag) {
        this.useFlag = useFlag;
    }

    public BigDecimal getPledgeRatio() {
        return pledgeRatio;
    }

    public void setPledgeRatio(BigDecimal pledgeRatio) {
        this.pledgeRatio = pledgeRatio;
    }

    public String getBizTypeName() {
        return bizTypeName;
    }

    public void setBizTypeName(String bizTypeName) {
        this.bizTypeName = bizTypeName;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public String getIsCheck() {
        return isCheck;
    }

    public void setIsCheck(String isCheck) {
        this.isCheck = isCheck;
    }

    public String getGuaranteeType() {
        return guaranteeType;
    }

    public void setGuaranteeType(String guaranteeType) {
        this.guaranteeType = guaranteeType;
    }

    public String getPledgor() {
        return pledgor;
    }

    public void setPledgor(String pledgor) {
        this.pledgor = pledgor;
    }

    public BigDecimal getPledgeAmount() {
        return pledgeAmount;
    }

    public void setPledgeAmount(BigDecimal pledgeAmount) {
        this.pledgeAmount = pledgeAmount;
    }

    public BigDecimal getNetWorthAmouint() {
        return netWorthAmouint;
    }

    public void setNetWorthAmouint(BigDecimal netWorthAmouint) {
        this.netWorthAmouint = netWorthAmouint;
    }

    @Override
    public String toString() {
        return "GwmsGuaranteePledgeDO{" +
                "id=" + id +
                ", guaranteeId=" + guaranteeId +
                ", ptCode=" + ptCode +
                ", pledgeId=" + pledgeId +
                ", pledgeNo=" + pledgeNo +
                ", evalAmount=" + evalAmount +
                ", amount=" + amount +
                ", useFlag=" + useFlag +
                ", pledgeRatio=" + pledgeRatio +
                ", bizTypeName=" + bizTypeName +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", isCheck=" + isCheck +
                ", guaranteeType=" + guaranteeType +
                ", pledgor=" + pledgor +
                ", pledgeAmount=" + pledgeAmount +
                ", netWorthAmouint=" + netWorthAmouint +
                "}";
    }
}
