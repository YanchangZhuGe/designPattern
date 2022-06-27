package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.sql.Blob;
import java.time.LocalDateTime;

/**
 * <p>
 * 付款单工单
 * </p>
 *
 * @author wyc
 * @since 2022-06-27
 */
@TableName("PTMS_PAYMENT_ORDER")
public class PtmsPaymentOrderDO {

    /**
     * 付款单流水号
     */
    private BigDecimal payId;

    /**
     * 父付款单流水号
     */
    private BigDecimal parentPayId;

    /**
     * 申请单流水号(逗号分割)
     */
    private String applyIds;

    /**
     * 工作流程ID
     */
    private String flowCaseId;

    /**
     * 支付模板
     */
    private String paymentTemplate;

    /**
     * 结算工具编号
     */
    private String stCode;

    /**
     * 付款金额
     */
    private BigDecimal amount;

    /**
     * 币种
     */
    private String currencyNo;

    private String currencyName;

    /**
     * 付款日期
     */
    private LocalDateTime actDate;

    /**
     * 付款申请类型
     */
    private String payType;

    /**
     * 加急标记，0：不加急；1：加急
     */
    private BigDecimal urgentFlag;

    /**
     * 是否直连 0：非直联；1：直联
     */
    private BigDecimal isConnect;

    /**
     * 对私标记，0：对公；1：对私
     */
    private BigDecimal isPerson;

    /**
     * 集团内 0：否；1：是
     */
    private BigDecimal isInGroup;

    /**
     * 对内标记，0：对外付款；1：对内付款
     */
    private BigDecimal isInner;

    /**
     * 内转标记，0：非内转付款；1：内转付款
     */
    private BigDecimal payInner;

    /**
     * 跨行标记，0：本行；1：跨行
     */
    private BigDecimal interBank;

    /**
     * 付款状态
     */
    private String payOrderState;

    /**
     * 操作单位编号
     */
    private String cltNo;

    /**
     * 付款单位编号
     */
    private String payCltNo;

    /**
     * 付款单位名称
     */
    private String payCltName;

    /**
     * 付方账户编号
     */
    private String payActCode;

    /**
     * 付方账号
     */
    private String payAccountNo;

    /**
     * 付方账号名称
     */
    private String payAccountName;

    /**
     * 付款银行编号
     */
    private String payBankNo;

    /**
     * 付款银行名称
     */
    private String payBankName;

    /**
     * 付款方开户行名称
     */
    private String payBranchBankName;

    /**
     * 内部账号
     */
    private String inAccountNo;

    /**
     * 收方单位编号
     */
    private String recCltNo;

    /**
     * 收方单位名称
     */
    private String recCltName;

    /**
     * 收方账户编号
     */
    private String recActCode;

    /**
     * 收方账号
     */
    private String recAccountNo;

    /**
     * 收方名称/户名
     */
    private String recName;

    /**
     * 收方联行号
     */
    private String recCnaps;

    /**
     * 收方银行编号（大行）
     */
    private String recBankNo;

    /**
     * 收款大行名称
     */
    private String recBankName;

    /**
     * 收方开户行名称
     */
    private String recBranchBankName;

    /**
     * 收方地区编码
     */
    private String recRegNo;

    /**
     * 说明
     */
    private String explain;

    /**
     * 预算科目
     */
    private String budgetAccountCode;

    /**
     * 预算科目
     */
    private String budgetAccountName;

    /**
     * 预算号
     */
    private String budgetCode;

    /**
     * 现金流编码
     */
    private String cashFlowNo;

    /**
     * 现金流名称
     */
    private String cashFlowName;

    /**
     * 款项类别
     */
    private String paymentCategoryNo;

    /**
     * 款项类别名称
     */
    private String paymentCategoryName;

    /**
     * 其他业务字段json
     */
    private Blob businessField;

    /**
     * 修改时，不可变更字段JSON(申请单有值字段)
     */
    private Blob unEditField;

    /**
     * 是否使用融资 0：否；1：是
     */
    private BigDecimal isUseGdt;

    /**
     * 关联业务
     */
    private String relBusinessType;

    /**
     * ERP唯一标识
     */
    private String erpId;

    /**
     * 凭证号|ERP单据号
     */
    private String erpNo;

    /**
     * 来源渠道
     */
    private String payChannel;

    /**
     * 来源渠道名称
     */
    private String payChannelName;

    /**
     * 备注
     */
    private String memo;

    /**
     * 录入人名称
     */
    private String inputPerson;

    /**
     * 付款经办人
     */
    private String payPerson;

    /**
     * 审批意见
     */
    private String reason;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 最后更新时间
     */
    private LocalDateTime lastUpdateTime;

    /**
     * 银行返回信息
     */
    private String retMsg;

    /**
     * 是否废弃：1-废弃
     */
    private BigDecimal isAbandoned;

    /**
     * 是否已经失败重发 0或者空：未重发；1：已重发
     */
    private BigDecimal isRepeat;

    /**
     * 是否失败重发生成的支付单 0不是；1是
     */
    private BigDecimal isRepeatOrder;

    /**
     * 委托收款状态：0-初始化；1-认可；2-拒付；3-有效；4-无效
     */
    private BigDecimal entrustState;

    /**
     * 认可/拒付原因
     */
    private String entrustReason;

    /**
     * 仲裁意见
     */
    private String entrustArbitrationOpinion;

    /**
     * 委托收款-仲裁结果：0-其它；1-仲裁有效
     */
    private BigDecimal isEntrustArbitration;

    /**
     * 异常原因
     */
    private String abnormalCause;

    /**
     * 期望付款日期
     */
    private LocalDateTime actualPayDate;

    /**
     * 0,未做账; 1,做账成功; 2,做账失败
     */
    private BigDecimal ebdFlag;

    /**
     * 0,未发BP; 1,发BP成功; 2,发BP失败
     */
    private BigDecimal bpFlag;

    /**
     * 异步发BP状态: 0-未处理；1-处理中；2-已处理
     */
    private BigDecimal execSendFlag;

    /**
     * 是否线下处理
     */
    private BigDecimal offlineDeal;

    /**
     * 指纹码
     */
    private String fingerCode;

    /**
     * 支付单状态名称
     */
    private String orderStateName;

    /**
     * 网上支付方式:1代理支付,2 直接支付,3 资金下拨,4 财务公司内转,5 线下调拨,6 主动收款
     */
    private String payModeCode;

    /**
     * 是否自动生成的支付单
     */
    private BigDecimal isAutoPay;

    private String cltName;

    private String inputPersonName;

    private String inputCltName;

    public BigDecimal getPayId() {
        return payId;
    }

    public void setPayId(BigDecimal payId) {
        this.payId = payId;
    }
    public BigDecimal getParentPayId() {
        return parentPayId;
    }

    public void setParentPayId(BigDecimal parentPayId) {
        this.parentPayId = parentPayId;
    }
    public String getApplyIds() {
        return applyIds;
    }

    public void setApplyIds(String applyIds) {
        this.applyIds = applyIds;
    }
    public String getFlowCaseId() {
        return flowCaseId;
    }

    public void setFlowCaseId(String flowCaseId) {
        this.flowCaseId = flowCaseId;
    }
    public String getPaymentTemplate() {
        return paymentTemplate;
    }

    public void setPaymentTemplate(String paymentTemplate) {
        this.paymentTemplate = paymentTemplate;
    }
    public String getStCode() {
        return stCode;
    }

    public void setStCode(String stCode) {
        this.stCode = stCode;
    }
    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    public String getCurrencyNo() {
        return currencyNo;
    }

    public void setCurrencyNo(String currencyNo) {
        this.currencyNo = currencyNo;
    }
    public String getCurrencyName() {
        return currencyName;
    }

    public void setCurrencyName(String currencyName) {
        this.currencyName = currencyName;
    }
    public LocalDateTime getActDate() {
        return actDate;
    }

    public void setActDate(LocalDateTime actDate) {
        this.actDate = actDate;
    }
    public String getPayType() {
        return payType;
    }

    public void setPayType(String payType) {
        this.payType = payType;
    }
    public BigDecimal getUrgentFlag() {
        return urgentFlag;
    }

    public void setUrgentFlag(BigDecimal urgentFlag) {
        this.urgentFlag = urgentFlag;
    }
    public BigDecimal getIsConnect() {
        return isConnect;
    }

    public void setIsConnect(BigDecimal isConnect) {
        this.isConnect = isConnect;
    }
    public BigDecimal getIsPerson() {
        return isPerson;
    }

    public void setIsPerson(BigDecimal isPerson) {
        this.isPerson = isPerson;
    }
    public BigDecimal getIsInGroup() {
        return isInGroup;
    }

    public void setIsInGroup(BigDecimal isInGroup) {
        this.isInGroup = isInGroup;
    }
    public BigDecimal getIsInner() {
        return isInner;
    }

    public void setIsInner(BigDecimal isInner) {
        this.isInner = isInner;
    }
    public BigDecimal getPayInner() {
        return payInner;
    }

    public void setPayInner(BigDecimal payInner) {
        this.payInner = payInner;
    }
    public BigDecimal getInterBank() {
        return interBank;
    }

    public void setInterBank(BigDecimal interBank) {
        this.interBank = interBank;
    }
    public String getPayOrderState() {
        return payOrderState;
    }

    public void setPayOrderState(String payOrderState) {
        this.payOrderState = payOrderState;
    }
    public String getCltNo() {
        return cltNo;
    }

    public void setCltNo(String cltNo) {
        this.cltNo = cltNo;
    }
    public String getPayCltNo() {
        return payCltNo;
    }

    public void setPayCltNo(String payCltNo) {
        this.payCltNo = payCltNo;
    }
    public String getPayCltName() {
        return payCltName;
    }

    public void setPayCltName(String payCltName) {
        this.payCltName = payCltName;
    }
    public String getPayActCode() {
        return payActCode;
    }

    public void setPayActCode(String payActCode) {
        this.payActCode = payActCode;
    }
    public String getPayAccountNo() {
        return payAccountNo;
    }

    public void setPayAccountNo(String payAccountNo) {
        this.payAccountNo = payAccountNo;
    }
    public String getPayAccountName() {
        return payAccountName;
    }

    public void setPayAccountName(String payAccountName) {
        this.payAccountName = payAccountName;
    }
    public String getPayBankNo() {
        return payBankNo;
    }

    public void setPayBankNo(String payBankNo) {
        this.payBankNo = payBankNo;
    }
    public String getPayBankName() {
        return payBankName;
    }

    public void setPayBankName(String payBankName) {
        this.payBankName = payBankName;
    }
    public String getPayBranchBankName() {
        return payBranchBankName;
    }

    public void setPayBranchBankName(String payBranchBankName) {
        this.payBranchBankName = payBranchBankName;
    }
    public String getInAccountNo() {
        return inAccountNo;
    }

    public void setInAccountNo(String inAccountNo) {
        this.inAccountNo = inAccountNo;
    }
    public String getRecCltNo() {
        return recCltNo;
    }

    public void setRecCltNo(String recCltNo) {
        this.recCltNo = recCltNo;
    }
    public String getRecCltName() {
        return recCltName;
    }

    public void setRecCltName(String recCltName) {
        this.recCltName = recCltName;
    }
    public String getRecActCode() {
        return recActCode;
    }

    public void setRecActCode(String recActCode) {
        this.recActCode = recActCode;
    }
    public String getRecAccountNo() {
        return recAccountNo;
    }

    public void setRecAccountNo(String recAccountNo) {
        this.recAccountNo = recAccountNo;
    }
    public String getRecName() {
        return recName;
    }

    public void setRecName(String recName) {
        this.recName = recName;
    }
    public String getRecCnaps() {
        return recCnaps;
    }

    public void setRecCnaps(String recCnaps) {
        this.recCnaps = recCnaps;
    }
    public String getRecBankNo() {
        return recBankNo;
    }

    public void setRecBankNo(String recBankNo) {
        this.recBankNo = recBankNo;
    }
    public String getRecBankName() {
        return recBankName;
    }

    public void setRecBankName(String recBankName) {
        this.recBankName = recBankName;
    }
    public String getRecBranchBankName() {
        return recBranchBankName;
    }

    public void setRecBranchBankName(String recBranchBankName) {
        this.recBranchBankName = recBranchBankName;
    }
    public String getRecRegNo() {
        return recRegNo;
    }

    public void setRecRegNo(String recRegNo) {
        this.recRegNo = recRegNo;
    }
    public String getExplain() {
        return explain;
    }

    public void setExplain(String explain) {
        this.explain = explain;
    }
    public String getBudgetAccountCode() {
        return budgetAccountCode;
    }

    public void setBudgetAccountCode(String budgetAccountCode) {
        this.budgetAccountCode = budgetAccountCode;
    }
    public String getBudgetAccountName() {
        return budgetAccountName;
    }

    public void setBudgetAccountName(String budgetAccountName) {
        this.budgetAccountName = budgetAccountName;
    }
    public String getBudgetCode() {
        return budgetCode;
    }

    public void setBudgetCode(String budgetCode) {
        this.budgetCode = budgetCode;
    }
    public String getCashFlowNo() {
        return cashFlowNo;
    }

    public void setCashFlowNo(String cashFlowNo) {
        this.cashFlowNo = cashFlowNo;
    }
    public String getCashFlowName() {
        return cashFlowName;
    }

    public void setCashFlowName(String cashFlowName) {
        this.cashFlowName = cashFlowName;
    }
    public String getPaymentCategoryNo() {
        return paymentCategoryNo;
    }

    public void setPaymentCategoryNo(String paymentCategoryNo) {
        this.paymentCategoryNo = paymentCategoryNo;
    }
    public String getPaymentCategoryName() {
        return paymentCategoryName;
    }

    public void setPaymentCategoryName(String paymentCategoryName) {
        this.paymentCategoryName = paymentCategoryName;
    }
    public Blob getBusinessField() {
        return businessField;
    }

    public void setBusinessField(Blob businessField) {
        this.businessField = businessField;
    }
    public Blob getUnEditField() {
        return unEditField;
    }

    public void setUnEditField(Blob unEditField) {
        this.unEditField = unEditField;
    }
    public BigDecimal getIsUseGdt() {
        return isUseGdt;
    }

    public void setIsUseGdt(BigDecimal isUseGdt) {
        this.isUseGdt = isUseGdt;
    }
    public String getRelBusinessType() {
        return relBusinessType;
    }

    public void setRelBusinessType(String relBusinessType) {
        this.relBusinessType = relBusinessType;
    }
    public String getErpId() {
        return erpId;
    }

    public void setErpId(String erpId) {
        this.erpId = erpId;
    }
    public String getErpNo() {
        return erpNo;
    }

    public void setErpNo(String erpNo) {
        this.erpNo = erpNo;
    }
    public String getPayChannel() {
        return payChannel;
    }

    public void setPayChannel(String payChannel) {
        this.payChannel = payChannel;
    }
    public String getPayChannelName() {
        return payChannelName;
    }

    public void setPayChannelName(String payChannelName) {
        this.payChannelName = payChannelName;
    }
    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
    public String getInputPerson() {
        return inputPerson;
    }

    public void setInputPerson(String inputPerson) {
        this.inputPerson = inputPerson;
    }
    public String getPayPerson() {
        return payPerson;
    }

    public void setPayPerson(String payPerson) {
        this.payPerson = payPerson;
    }
    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
    public LocalDateTime getLastUpdateTime() {
        return lastUpdateTime;
    }

    public void setLastUpdateTime(LocalDateTime lastUpdateTime) {
        this.lastUpdateTime = lastUpdateTime;
    }
    public String getRetMsg() {
        return retMsg;
    }

    public void setRetMsg(String retMsg) {
        this.retMsg = retMsg;
    }
    public BigDecimal getIsAbandoned() {
        return isAbandoned;
    }

    public void setIsAbandoned(BigDecimal isAbandoned) {
        this.isAbandoned = isAbandoned;
    }
    public BigDecimal getIsRepeat() {
        return isRepeat;
    }

    public void setIsRepeat(BigDecimal isRepeat) {
        this.isRepeat = isRepeat;
    }
    public BigDecimal getIsRepeatOrder() {
        return isRepeatOrder;
    }

    public void setIsRepeatOrder(BigDecimal isRepeatOrder) {
        this.isRepeatOrder = isRepeatOrder;
    }
    public BigDecimal getEntrustState() {
        return entrustState;
    }

    public void setEntrustState(BigDecimal entrustState) {
        this.entrustState = entrustState;
    }
    public String getEntrustReason() {
        return entrustReason;
    }

    public void setEntrustReason(String entrustReason) {
        this.entrustReason = entrustReason;
    }
    public String getEntrustArbitrationOpinion() {
        return entrustArbitrationOpinion;
    }

    public void setEntrustArbitrationOpinion(String entrustArbitrationOpinion) {
        this.entrustArbitrationOpinion = entrustArbitrationOpinion;
    }
    public BigDecimal getIsEntrustArbitration() {
        return isEntrustArbitration;
    }

    public void setIsEntrustArbitration(BigDecimal isEntrustArbitration) {
        this.isEntrustArbitration = isEntrustArbitration;
    }
    public String getAbnormalCause() {
        return abnormalCause;
    }

    public void setAbnormalCause(String abnormalCause) {
        this.abnormalCause = abnormalCause;
    }
    public LocalDateTime getActualPayDate() {
        return actualPayDate;
    }

    public void setActualPayDate(LocalDateTime actualPayDate) {
        this.actualPayDate = actualPayDate;
    }
    public BigDecimal getEbdFlag() {
        return ebdFlag;
    }

    public void setEbdFlag(BigDecimal ebdFlag) {
        this.ebdFlag = ebdFlag;
    }
    public BigDecimal getBpFlag() {
        return bpFlag;
    }

    public void setBpFlag(BigDecimal bpFlag) {
        this.bpFlag = bpFlag;
    }
    public BigDecimal getExecSendFlag() {
        return execSendFlag;
    }

    public void setExecSendFlag(BigDecimal execSendFlag) {
        this.execSendFlag = execSendFlag;
    }
    public BigDecimal getOfflineDeal() {
        return offlineDeal;
    }

    public void setOfflineDeal(BigDecimal offlineDeal) {
        this.offlineDeal = offlineDeal;
    }
    public String getFingerCode() {
        return fingerCode;
    }

    public void setFingerCode(String fingerCode) {
        this.fingerCode = fingerCode;
    }
    public String getOrderStateName() {
        return orderStateName;
    }

    public void setOrderStateName(String orderStateName) {
        this.orderStateName = orderStateName;
    }
    public String getPayModeCode() {
        return payModeCode;
    }

    public void setPayModeCode(String payModeCode) {
        this.payModeCode = payModeCode;
    }
    public BigDecimal getIsAutoPay() {
        return isAutoPay;
    }

    public void setIsAutoPay(BigDecimal isAutoPay) {
        this.isAutoPay = isAutoPay;
    }
    public String getCltName() {
        return cltName;
    }

    public void setCltName(String cltName) {
        this.cltName = cltName;
    }
    public String getInputPersonName() {
        return inputPersonName;
    }

    public void setInputPersonName(String inputPersonName) {
        this.inputPersonName = inputPersonName;
    }
    public String getInputCltName() {
        return inputCltName;
    }

    public void setInputCltName(String inputCltName) {
        this.inputCltName = inputCltName;
    }

    @Override
    public String toString() {
        return "PtmsPaymentOrderDO{" +
            "payId=" + payId +
            ", parentPayId=" + parentPayId +
            ", applyIds=" + applyIds +
            ", flowCaseId=" + flowCaseId +
            ", paymentTemplate=" + paymentTemplate +
            ", stCode=" + stCode +
            ", amount=" + amount +
            ", currencyNo=" + currencyNo +
            ", currencyName=" + currencyName +
            ", actDate=" + actDate +
            ", payType=" + payType +
            ", urgentFlag=" + urgentFlag +
            ", isConnect=" + isConnect +
            ", isPerson=" + isPerson +
            ", isInGroup=" + isInGroup +
            ", isInner=" + isInner +
            ", payInner=" + payInner +
            ", interBank=" + interBank +
            ", payOrderState=" + payOrderState +
            ", cltNo=" + cltNo +
            ", payCltNo=" + payCltNo +
            ", payCltName=" + payCltName +
            ", payActCode=" + payActCode +
            ", payAccountNo=" + payAccountNo +
            ", payAccountName=" + payAccountName +
            ", payBankNo=" + payBankNo +
            ", payBankName=" + payBankName +
            ", payBranchBankName=" + payBranchBankName +
            ", inAccountNo=" + inAccountNo +
            ", recCltNo=" + recCltNo +
            ", recCltName=" + recCltName +
            ", recActCode=" + recActCode +
            ", recAccountNo=" + recAccountNo +
            ", recName=" + recName +
            ", recCnaps=" + recCnaps +
            ", recBankNo=" + recBankNo +
            ", recBankName=" + recBankName +
            ", recBranchBankName=" + recBranchBankName +
            ", recRegNo=" + recRegNo +
            ", explain=" + explain +
            ", budgetAccountCode=" + budgetAccountCode +
            ", budgetAccountName=" + budgetAccountName +
            ", budgetCode=" + budgetCode +
            ", cashFlowNo=" + cashFlowNo +
            ", cashFlowName=" + cashFlowName +
            ", paymentCategoryNo=" + paymentCategoryNo +
            ", paymentCategoryName=" + paymentCategoryName +
            ", businessField=" + businessField +
            ", unEditField=" + unEditField +
            ", isUseGdt=" + isUseGdt +
            ", relBusinessType=" + relBusinessType +
            ", erpId=" + erpId +
            ", erpNo=" + erpNo +
            ", payChannel=" + payChannel +
            ", payChannelName=" + payChannelName +
            ", memo=" + memo +
            ", inputPerson=" + inputPerson +
            ", payPerson=" + payPerson +
            ", reason=" + reason +
            ", createTime=" + createTime +
            ", lastUpdateTime=" + lastUpdateTime +
            ", retMsg=" + retMsg +
            ", isAbandoned=" + isAbandoned +
            ", isRepeat=" + isRepeat +
            ", isRepeatOrder=" + isRepeatOrder +
            ", entrustState=" + entrustState +
            ", entrustReason=" + entrustReason +
            ", entrustArbitrationOpinion=" + entrustArbitrationOpinion +
            ", isEntrustArbitration=" + isEntrustArbitration +
            ", abnormalCause=" + abnormalCause +
            ", actualPayDate=" + actualPayDate +
            ", ebdFlag=" + ebdFlag +
            ", bpFlag=" + bpFlag +
            ", execSendFlag=" + execSendFlag +
            ", offlineDeal=" + offlineDeal +
            ", fingerCode=" + fingerCode +
            ", orderStateName=" + orderStateName +
            ", payModeCode=" + payModeCode +
            ", isAutoPay=" + isAutoPay +
            ", cltName=" + cltName +
            ", inputPersonName=" + inputPersonName +
            ", inputCltName=" + inputCltName +
        "}";
    }
}
