package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 账户明细记录表
 * </p>
 *
 * @author wyc
 * @since 2022-05-07
 */
@TableName("AIMS_ACCOUNT_RECORD")
public class AimsAccountRecordDO {

    /**
     * 明细记录ID
     */
    private BigDecimal recordId;

    /**
     * 账户流水号
     */
    private BigDecimal accountid;

    /**
     * 银企互联系统明细唯一标识字段
     */
    private BigDecimal bpId;

    /**
     * 账户代码
     */
    private String accountcode;

    /**
     * 明细日期
     */
    private LocalDateTime recordDate;

    /**
     * 本方银行编号
     */
    private String bankno;

    /**
     * 本方账号
     */
    private String accountno;

    /**
     * 本方内部账号
     */
    private String accountInnerNumber;

    /**
     * 本方内部户名
     */
    private String accountInnerName;

    /**
     * 收支方向 1：支出；2：收入
     */
    private BigDecimal balanceDir;

    /**
     * 金额
     */
    private BigDecimal amount;

    /**
     * 余额
     */
    private BigDecimal balance;

    /**
     * 币种
     */
    private String currencyCode;

    /**
     * 对方账号
     */
    private String opAccountNo;

    /**
     * 对方户名
     */
    private String opAccountName;

    /**
     * 对方开户行名
     */
    private String opBranchName;

    /**
     * 摘要
     */
    private String explain;

    /**
     * 备注
     */
    private String remark;

    /**
     * 附言
     */
    private String postScript;

    /**
     * 银行流水号
     */
    private String hostId;

    /**
     * 单据类型
     */
    private String ticketType;

    /**
     * 单据编号
     */
    private String ticketNumber;

    /**
     * 银行记账时间
     */
    private LocalDateTime hostTime;

    /**
     * 记录收到时间
     */
    private LocalDateTime recerivedTime;

    /**
     * 交易类型
     */
    private String transType;

    /**
     * 数据源类型，01：BP通知；02：导入
     */
    private String dataType;

    /**
     * 原始业务标识
     */
    private String sourceId;

    /**
     * 上收标记
     */
    private BigDecimal upFlag;

    /**
     * 同步GTSA状态-1失败，0暂存，1成功
     */
    private BigDecimal sendGtsaState;

    /**
     * 同步GTSA失败原因
     */
    private String sendGtsaMsg;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 预算单元编号
     */
    private String cfbMemberno;

    /**
     * 预算科目编号
     */
    private String cfbKmcode;

    /**
     * 预算号
     */
    private String budgetCode;

    /**
     * 账户明细顺序(按天排序)
     */
    private BigDecimal dayRecordId;

    /**
     * 补填结果0未补填1已补填
     */
    private BigDecimal refillResult;

    /**
     * 同步主键
     */
    private String reId;

    public BigDecimal getRecordId() {
        return recordId;
    }

    public void setRecordId(BigDecimal recordId) {
        this.recordId = recordId;
    }
    public BigDecimal getAccountid() {
        return accountid;
    }

    public void setAccountid(BigDecimal accountid) {
        this.accountid = accountid;
    }
    public BigDecimal getBpId() {
        return bpId;
    }

    public void setBpId(BigDecimal bpId) {
        this.bpId = bpId;
    }
    public String getAccountcode() {
        return accountcode;
    }

    public void setAccountcode(String accountcode) {
        this.accountcode = accountcode;
    }
    public LocalDateTime getRecordDate() {
        return recordDate;
    }

    public void setRecordDate(LocalDateTime recordDate) {
        this.recordDate = recordDate;
    }
    public String getBankno() {
        return bankno;
    }

    public void setBankno(String bankno) {
        this.bankno = bankno;
    }
    public String getAccountno() {
        return accountno;
    }

    public void setAccountno(String accountno) {
        this.accountno = accountno;
    }
    public String getAccountInnerNumber() {
        return accountInnerNumber;
    }

    public void setAccountInnerNumber(String accountInnerNumber) {
        this.accountInnerNumber = accountInnerNumber;
    }
    public String getAccountInnerName() {
        return accountInnerName;
    }

    public void setAccountInnerName(String accountInnerName) {
        this.accountInnerName = accountInnerName;
    }
    public BigDecimal getBalanceDir() {
        return balanceDir;
    }

    public void setBalanceDir(BigDecimal balanceDir) {
        this.balanceDir = balanceDir;
    }
    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }
    public String getCurrencyCode() {
        return currencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }
    public String getOpAccountNo() {
        return opAccountNo;
    }

    public void setOpAccountNo(String opAccountNo) {
        this.opAccountNo = opAccountNo;
    }
    public String getOpAccountName() {
        return opAccountName;
    }

    public void setOpAccountName(String opAccountName) {
        this.opAccountName = opAccountName;
    }
    public String getOpBranchName() {
        return opBranchName;
    }

    public void setOpBranchName(String opBranchName) {
        this.opBranchName = opBranchName;
    }
    public String getExplain() {
        return explain;
    }

    public void setExplain(String explain) {
        this.explain = explain;
    }
    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
    public String getPostScript() {
        return postScript;
    }

    public void setPostScript(String postScript) {
        this.postScript = postScript;
    }
    public String getHostId() {
        return hostId;
    }

    public void setHostId(String hostId) {
        this.hostId = hostId;
    }
    public String getTicketType() {
        return ticketType;
    }

    public void setTicketType(String ticketType) {
        this.ticketType = ticketType;
    }
    public String getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(String ticketNumber) {
        this.ticketNumber = ticketNumber;
    }
    public LocalDateTime getHostTime() {
        return hostTime;
    }

    public void setHostTime(LocalDateTime hostTime) {
        this.hostTime = hostTime;
    }
    public LocalDateTime getRecerivedTime() {
        return recerivedTime;
    }

    public void setRecerivedTime(LocalDateTime recerivedTime) {
        this.recerivedTime = recerivedTime;
    }
    public String getTransType() {
        return transType;
    }

    public void setTransType(String transType) {
        this.transType = transType;
    }
    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }
    public String getSourceId() {
        return sourceId;
    }

    public void setSourceId(String sourceId) {
        this.sourceId = sourceId;
    }
    public BigDecimal getUpFlag() {
        return upFlag;
    }

    public void setUpFlag(BigDecimal upFlag) {
        this.upFlag = upFlag;
    }
    public BigDecimal getSendGtsaState() {
        return sendGtsaState;
    }

    public void setSendGtsaState(BigDecimal sendGtsaState) {
        this.sendGtsaState = sendGtsaState;
    }
    public String getSendGtsaMsg() {
        return sendGtsaMsg;
    }

    public void setSendGtsaMsg(String sendGtsaMsg) {
        this.sendGtsaMsg = sendGtsaMsg;
    }
    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
    public String getCfbMemberno() {
        return cfbMemberno;
    }

    public void setCfbMemberno(String cfbMemberno) {
        this.cfbMemberno = cfbMemberno;
    }
    public String getCfbKmcode() {
        return cfbKmcode;
    }

    public void setCfbKmcode(String cfbKmcode) {
        this.cfbKmcode = cfbKmcode;
    }
    public String getBudgetCode() {
        return budgetCode;
    }

    public void setBudgetCode(String budgetCode) {
        this.budgetCode = budgetCode;
    }
    public BigDecimal getDayRecordId() {
        return dayRecordId;
    }

    public void setDayRecordId(BigDecimal dayRecordId) {
        this.dayRecordId = dayRecordId;
    }
    public BigDecimal getRefillResult() {
        return refillResult;
    }

    public void setRefillResult(BigDecimal refillResult) {
        this.refillResult = refillResult;
    }
    public String getReId() {
        return reId;
    }

    public void setReId(String reId) {
        this.reId = reId;
    }

    @Override
    public String toString() {
        return "AimsAccountRecordDO{" +
            "recordId=" + recordId +
            ", accountid=" + accountid +
            ", bpId=" + bpId +
            ", accountcode=" + accountcode +
            ", recordDate=" + recordDate +
            ", bankno=" + bankno +
            ", accountno=" + accountno +
            ", accountInnerNumber=" + accountInnerNumber +
            ", accountInnerName=" + accountInnerName +
            ", balanceDir=" + balanceDir +
            ", amount=" + amount +
            ", balance=" + balance +
            ", currencyCode=" + currencyCode +
            ", opAccountNo=" + opAccountNo +
            ", opAccountName=" + opAccountName +
            ", opBranchName=" + opBranchName +
            ", explain=" + explain +
            ", remark=" + remark +
            ", postScript=" + postScript +
            ", hostId=" + hostId +
            ", ticketType=" + ticketType +
            ", ticketNumber=" + ticketNumber +
            ", hostTime=" + hostTime +
            ", recerivedTime=" + recerivedTime +
            ", transType=" + transType +
            ", dataType=" + dataType +
            ", sourceId=" + sourceId +
            ", upFlag=" + upFlag +
            ", sendGtsaState=" + sendGtsaState +
            ", sendGtsaMsg=" + sendGtsaMsg +
            ", createTime=" + createTime +
            ", cfbMemberno=" + cfbMemberno +
            ", cfbKmcode=" + cfbKmcode +
            ", budgetCode=" + budgetCode +
            ", dayRecordId=" + dayRecordId +
            ", refillResult=" + refillResult +
            ", reId=" + reId +
        "}";
    }
}
