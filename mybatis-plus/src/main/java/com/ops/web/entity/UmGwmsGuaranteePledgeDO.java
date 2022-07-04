package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 担保合同押品信息工单表
 * </p>
 *
 * @author wyc
 * @since 2022-07-04
 */
@TableName("UM_GWMS_GUARANTEE_PLEDGE")
public class UmGwmsGuaranteePledgeDO {

    /**
     * ID
     */
    private BigDecimal id;

    /**
     * FMID
     */
    private BigDecimal fmid;

    /**
     * 关联抵质押物基础数据工单主键ID
     */
    private BigDecimal umId;

    /**
     * 抵（质）押类型
     */
    private String ptCode;

    /**
     * 物品ID（库存ID）
     */
    private BigDecimal pledgeId;

    /**
     * 物品编号(票号)
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
     * 净值
     */
    private BigDecimal netWorthAmouint;

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getFmid() {
        return fmid;
    }

    public void setFmid(BigDecimal fmid) {
        this.fmid = fmid;
    }

    public BigDecimal getUmId() {
        return umId;
    }

    public void setUmId(BigDecimal umId) {
        this.umId = umId;
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

    public BigDecimal getNetWorthAmouint() {
        return netWorthAmouint;
    }

    public void setNetWorthAmouint(BigDecimal netWorthAmouint) {
        this.netWorthAmouint = netWorthAmouint;
    }

    @Override
    public String toString() {
        return "UmGwmsGuaranteePledgeDO{" +
                "id=" + id +
                ", fmid=" + fmid +
                ", umId=" + umId +
                ", ptCode=" + ptCode +
                ", pledgeId=" + pledgeId +
                ", pledgeNo=" + pledgeNo +
                ", evalAmount=" + evalAmount +
                ", amount=" + amount +
                ", pledgeRatio=" + pledgeRatio +
                ", bizTypeName=" + bizTypeName +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", netWorthAmouint=" + netWorthAmouint +
                "}";
    }
}
