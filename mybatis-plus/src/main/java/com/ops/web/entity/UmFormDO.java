package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 
 * </p>
 *
 * @author wyc
 * @since 2022-05-13
 */
@TableName("UM_FORM")
public class UmFormDO {

    private BigDecimal fmid;

    private String fmCls;

    private String fmno;

    private String fmkey;

    private String title;

    private String topic;

    private LocalDateTime fmdate;

    private String memberNo;

    private String inputor;

    private String detail;

    private String remark;

    private String bizKey;

    private String channel;

    private BigDecimal state;

    private String caseid;

    private String curProc;

    private BigDecimal alertSelf;

    private BigDecimal alertOp;

    private BigDecimal alertFlow;

    private BigDecimal procResult;

    private BigDecimal errorFlag;

    private String errorCode;

    private String errorMsg;

    private String checkCode;

    private BigDecimal version;

    private BigDecimal etlTag;

    private LocalDateTime createTime;

    private LocalDateTime lastUpdateTime;

    private String bizNo;

    private String extended;

    private BigDecimal flowState;

    private String inputorName;

    public BigDecimal getFmid() {
        return fmid;
    }

    public void setFmid(BigDecimal fmid) {
        this.fmid = fmid;
    }
    public String getFmCls() {
        return fmCls;
    }

    public void setFmCls(String fmCls) {
        this.fmCls = fmCls;
    }
    public String getFmno() {
        return fmno;
    }

    public void setFmno(String fmno) {
        this.fmno = fmno;
    }
    public String getFmkey() {
        return fmkey;
    }

    public void setFmkey(String fmkey) {
        this.fmkey = fmkey;
    }
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }
    public LocalDateTime getFmdate() {
        return fmdate;
    }

    public void setFmdate(LocalDateTime fmdate) {
        this.fmdate = fmdate;
    }
    public String getMemberNo() {
        return memberNo;
    }

    public void setMemberNo(String memberNo) {
        this.memberNo = memberNo;
    }
    public String getInputor() {
        return inputor;
    }

    public void setInputor(String inputor) {
        this.inputor = inputor;
    }
    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }
    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }
    public String getBizKey() {
        return bizKey;
    }

    public void setBizKey(String bizKey) {
        this.bizKey = bizKey;
    }
    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }
    public BigDecimal getState() {
        return state;
    }

    public void setState(BigDecimal state) {
        this.state = state;
    }
    public String getCaseid() {
        return caseid;
    }

    public void setCaseid(String caseid) {
        this.caseid = caseid;
    }
    public String getCurProc() {
        return curProc;
    }

    public void setCurProc(String curProc) {
        this.curProc = curProc;
    }
    public BigDecimal getAlertSelf() {
        return alertSelf;
    }

    public void setAlertSelf(BigDecimal alertSelf) {
        this.alertSelf = alertSelf;
    }
    public BigDecimal getAlertOp() {
        return alertOp;
    }

    public void setAlertOp(BigDecimal alertOp) {
        this.alertOp = alertOp;
    }
    public BigDecimal getAlertFlow() {
        return alertFlow;
    }

    public void setAlertFlow(BigDecimal alertFlow) {
        this.alertFlow = alertFlow;
    }
    public BigDecimal getProcResult() {
        return procResult;
    }

    public void setProcResult(BigDecimal procResult) {
        this.procResult = procResult;
    }
    public BigDecimal getErrorFlag() {
        return errorFlag;
    }

    public void setErrorFlag(BigDecimal errorFlag) {
        this.errorFlag = errorFlag;
    }
    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }
    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }
    public String getCheckCode() {
        return checkCode;
    }

    public void setCheckCode(String checkCode) {
        this.checkCode = checkCode;
    }
    public BigDecimal getVersion() {
        return version;
    }

    public void setVersion(BigDecimal version) {
        this.version = version;
    }
    public BigDecimal getEtlTag() {
        return etlTag;
    }

    public void setEtlTag(BigDecimal etlTag) {
        this.etlTag = etlTag;
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
    public String getBizNo() {
        return bizNo;
    }

    public void setBizNo(String bizNo) {
        this.bizNo = bizNo;
    }
    public String getExtended() {
        return extended;
    }

    public void setExtended(String extended) {
        this.extended = extended;
    }
    public BigDecimal getFlowState() {
        return flowState;
    }

    public void setFlowState(BigDecimal flowState) {
        this.flowState = flowState;
    }
    public String getInputorName() {
        return inputorName;
    }

    public void setInputorName(String inputorName) {
        this.inputorName = inputorName;
    }

    @Override
    public String toString() {
        return "UmFormDO{" +
            "fmid=" + fmid +
            ", fmCls=" + fmCls +
            ", fmno=" + fmno +
            ", fmkey=" + fmkey +
            ", title=" + title +
            ", topic=" + topic +
            ", fmdate=" + fmdate +
            ", memberNo=" + memberNo +
            ", inputor=" + inputor +
            ", detail=" + detail +
            ", remark=" + remark +
            ", bizKey=" + bizKey +
            ", channel=" + channel +
            ", state=" + state +
            ", caseid=" + caseid +
            ", curProc=" + curProc +
            ", alertSelf=" + alertSelf +
            ", alertOp=" + alertOp +
            ", alertFlow=" + alertFlow +
            ", procResult=" + procResult +
            ", errorFlag=" + errorFlag +
            ", errorCode=" + errorCode +
            ", errorMsg=" + errorMsg +
            ", checkCode=" + checkCode +
            ", version=" + version +
            ", etlTag=" + etlTag +
            ", createTime=" + createTime +
            ", lastUpdateTime=" + lastUpdateTime +
            ", bizNo=" + bizNo +
            ", extended=" + extended +
            ", flowState=" + flowState +
            ", inputorName=" + inputorName +
        "}";
    }
}
