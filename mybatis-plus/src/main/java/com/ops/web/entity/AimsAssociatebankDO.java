package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 合作金融机构登记表
 * </p>
 *
 * @author wyc
 * @since 2022-07-05
 */
@TableName("AIMS_ASSOCIATEBANK")
public class AimsAssociatebankDO {

    /**
     * 流水号，自增
     */
    private BigDecimal assid;

    /**
     * 境内外 1：境外；0：境内
     */
    private String isabroad;

    /**
     * 银行/非银行 1：银行；0：非银行
     */
    private String infbank;

    /**
     * 所属金融机构
     */
    private String bankcode;

    /**
     * 联行号/网点编号
     */
    private String associatebankcode;

    /**
     * 合作金融网点
     */
    private String associatebankname;

    /**
     * 国家/地区编号
     */
    private String countryno;

    /**
     * 地区编码
     */
    private String regno;

    /**
     * 网点英文名称
     */
    private String englishname;

    /**
     * SWIFT号码
     */
    private String swiftcode;

    /**
     * 联系人
     */
    private String contact;

    /**
     * 联系电话
     */
    private String telphone;

    /**
     * 中文地址
     */
    private String cnaddress;

    /**
     * 英文地址
     */
    private String enaddress;

    /**
     * 备注
     */
    private String remark;

    /**
     * 附件信息描述
     */
    private String fileremark;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 最后更新时间
     */
    private LocalDateTime updateTime;

    public BigDecimal getAssid() {
        return assid;
    }

    public void setAssid(BigDecimal assid) {
        this.assid = assid;
    }

    public String getIsabroad() {
        return isabroad;
    }

    public void setIsabroad(String isabroad) {
        this.isabroad = isabroad;
    }

    public String getInfbank() {
        return infbank;
    }

    public void setInfbank(String infbank) {
        this.infbank = infbank;
    }

    public String getBankcode() {
        return bankcode;
    }

    public void setBankcode(String bankcode) {
        this.bankcode = bankcode;
    }

    public String getAssociatebankcode() {
        return associatebankcode;
    }

    public void setAssociatebankcode(String associatebankcode) {
        this.associatebankcode = associatebankcode;
    }

    public String getAssociatebankname() {
        return associatebankname;
    }

    public void setAssociatebankname(String associatebankname) {
        this.associatebankname = associatebankname;
    }

    public String getCountryno() {
        return countryno;
    }

    public void setCountryno(String countryno) {
        this.countryno = countryno;
    }

    public String getRegno() {
        return regno;
    }

    public void setRegno(String regno) {
        this.regno = regno;
    }

    public String getEnglishname() {
        return englishname;
    }

    public void setEnglishname(String englishname) {
        this.englishname = englishname;
    }

    public String getSwiftcode() {
        return swiftcode;
    }

    public void setSwiftcode(String swiftcode) {
        this.swiftcode = swiftcode;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getTelphone() {
        return telphone;
    }

    public void setTelphone(String telphone) {
        this.telphone = telphone;
    }

    public String getCnaddress() {
        return cnaddress;
    }

    public void setCnaddress(String cnaddress) {
        this.cnaddress = cnaddress;
    }

    public String getEnaddress() {
        return enaddress;
    }

    public void setEnaddress(String enaddress) {
        this.enaddress = enaddress;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getFileremark() {
        return fileremark;
    }

    public void setFileremark(String fileremark) {
        this.fileremark = fileremark;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "AimsAssociatebankDO{" +
                "assid=" + assid +
                ", isabroad=" + isabroad +
                ", infbank=" + infbank +
                ", bankcode=" + bankcode +
                ", associatebankcode=" + associatebankcode +
                ", associatebankname=" + associatebankname +
                ", countryno=" + countryno +
                ", regno=" + regno +
                ", englishname=" + englishname +
                ", swiftcode=" + swiftcode +
                ", contact=" + contact +
                ", telphone=" + telphone +
                ", cnaddress=" + cnaddress +
                ", enaddress=" + enaddress +
                ", remark=" + remark +
                ", fileremark=" + fileremark +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                "}";
    }
}
