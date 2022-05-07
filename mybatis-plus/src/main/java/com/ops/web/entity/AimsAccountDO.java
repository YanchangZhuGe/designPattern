package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 * 账户信息
 * </p>
 *
 * @author wyc
 * @since 2022-05-07
 */
@TableName("AIMS_ACCOUNT")
public class AimsAccountDO {

    /**
     * 账户id
     */
    private BigDecimal accountid;

    /**
     * 账户申请流水号
     */
    private BigDecimal applyid;

    /**
     * 账户代码
     */
    private String accountcode;

    /**
     * 单位编号
     */
    private String cltno;

    /**
     * 合作金融网点流水号(废弃)
     */
    private BigDecimal assid;

    /**
     * 合作金融网点编号(支行号)
     */
    private String branchBankNo;

    /**
     * 所属金融机构
     */
    private String bankno;

    /**
     * 境内外
     */
    private String isabroad;

    /**
     * 地区编码（开户地址）
     */
    private String regno;

    /**
     * 区域编码
     */
    private BigDecimal areaid;

    /**
     * 开户日期
     */
    private LocalDateTime openaccountdate;

    /**
     * 账号
     */
    private String accountno;

    /**
     * 真实账号
     */
    private String realAccountno;

    /**
     * 户名
     */
    private String accountname;

    /**
     * 助记名
     */
    private String memoryname;

    /**
     * 币种
     */
    private String currencyno;

    /**
     * 账户用途
     */
    private BigDecimal usageid;

    /**
     * 账户性质
     */
    private BigDecimal ctid;

    /**
     * 有效日期开始
     */
    private LocalDateTime vaildstartdate;

    /**
     * 有效日期结束
     */
    private LocalDateTime vaildenddate;

    /**
     * 账户类别
     */
    private String natureid;

    /**
     * 外汇业务类型 
     */
    private BigDecimal foreigntype;

    /**
     * 联网方式
     */
    private String associateflag;

    /**
     * 单位/项目地址
     */
    private String arrdess;

    /**
     * 备注
     */
    private String cnremark;

    /**
     * 1：沉睡,0：正常
     */
    private BigDecimal isSleep;

    /**
     * 统计编码1
     */
    private String tempcode1;

    /**
     * 统计编码2
     */
    private String tempcode2;

    /**
     * 统计编码3
     */
    private String tempcode3;

    /**
     * 统计编码4
     */
    private String tempcode4;

    /**
     * 统计编码5
     */
    private String tempcode5;

    /**
     * 统计编码6
     */
    private String tempcode6;

    /**
     * 统计编码7
     */
    private String tempcode7;

    /**
     * 统计编码8
     */
    private String tempcode8;

    /**
     * 统计编码9
     */
    private String tempcode9;

    /**
     * 统计编码10
     */
    private String tempcode10;

    /**
     * 账户状态
     */
    private BigDecimal acntstate;

    /**
     * 销户日期
     */
    private LocalDateTime canceldate;

    /**
     * 销户备注
     */
    private String cancelremark;

    /**
     * 销户原因
     */
    private String cancelreason;

    /**
     * 附件内容描述
     */
    private String fileremark;

    /**
     * 创建人
     */
    private String createuser;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 最后修改时间
     */
    private LocalDateTime updateTime;

    /**
     * 可用余额
     */
    private BigDecimal availableBalance;

    /**
     * 账户余额
     */
    private BigDecimal accountBalance;

    /**
     * 实体账户
     */
    private String eaccount;

    /**
     * 对公电话
     */
    private String publicTelephone;

    /**
     * 客户经理
     */
    private String customerManager;

    /**
     * 客户经理电话
     */
    private String cmTelephone;

    /**
     * 客户经理邮箱
     */
    private String cmMail;

    /**
     * 取消销户时间
     */
    private LocalDateTime removecanceldate;

    /**
     * 取消销户原因
     */
    private String removecancelreason;

    /**
     * 销户之前的账户状态
     */
    private BigDecimal beforecalcelstate;

    /**
     * 是否扣减账户：0不是；1是
     */
    private BigDecimal isDeduct;

    /**
     * 是否监管账户(0-否 1-是)
     */
    private BigDecimal isEscrowaccount;

    /**
     * 直连联网方式:0 全部 1 现金 2 票据
     */
    private BigDecimal connectType;

    private String clableNo;

    private String iban;

    private String accountNameInEnglish;

    private BigDecimal outFlag;

    /**
     * 1:二级户2:三级户3:普通户4:联动户5:代理行账户6:虚拟户7:头寸户8:投资户9:代理投资户10:国内资金主账户11:国际资金主账户12:保证金账户13:多币种账户
     */
    private BigDecimal cashManageType;

    private Long vaildNumber;

    /**
     * 1:是 0:否
     */
    private BigDecimal isBillAccount;

    /**
     * 1:电票账户 2:回款账户 
     */
    private String billAccountType;

    /**
     * 1:是 0:否
     */
    private BigDecimal isStampLegalPerson;

    private String authorizeName;

    private String authorizeNo;

    private String legalPersonName;

    private String legalPersonNo;

    private String personStampName;

    private String moneyStampName;

    private String publicStampName;

    private String finacialCompanyStamp;

    /**
     * 是否有支付密码器
     */
    private BigDecimal isPaySecurity;

    /**
     * 制单UK保管人
     */
    private String makeUkHolder;

    /**
     * 复合UK保管人
     */
    private String checkUkHolder;

    private String backAccountStamp;

    /**
     * 交易限额/笔
     */
    private BigDecimal paylimitsTrans;

    /**
     * 交易限额/天
     */
    private BigDecimal paylimitsDay;

    /**
     * 提现限额/笔
     */
    private BigDecimal withdrawlimitsTrans;

    /**
     * 提现限额/天
     */
    private BigDecimal withdrawlimitsDay;

    /**
     * 提现限额/月
     */
    private BigDecimal withdrawlimitsMonth;

    /**
     * 账户负责人
     */
    private String accountCharge;

    /**
     * 申请部门
     */
    private String applyDepartment;

    /**
     * 账户申请人
     */
    private String applier;

    /**
     * 是否开通电票系统
     */
    private BigDecimal isEtsys;

    /**
     * 银行账户性质
     */
    private BigDecimal bankAccountNature;

    /**
     * 是否开通网银，0否；1是
     */
    private BigDecimal isEbank;

    /**
     * 是否归集：0否；1是
     */
    private BigDecimal isFts;

    /**
     * 归集主体
     */
    private String ftsMain;

    /**
     * 网银开通日期
     */
    private LocalDateTime ebankDate;

    /**
     * 存款类型
     */
    private BigDecimal depositType;

    public BigDecimal getAccountid() {
        return accountid;
    }

    public void setAccountid(BigDecimal accountid) {
        this.accountid = accountid;
    }
    public BigDecimal getApplyid() {
        return applyid;
    }

    public void setApplyid(BigDecimal applyid) {
        this.applyid = applyid;
    }
    public String getAccountcode() {
        return accountcode;
    }

    public void setAccountcode(String accountcode) {
        this.accountcode = accountcode;
    }
    public String getCltno() {
        return cltno;
    }

    public void setCltno(String cltno) {
        this.cltno = cltno;
    }
    public BigDecimal getAssid() {
        return assid;
    }

    public void setAssid(BigDecimal assid) {
        this.assid = assid;
    }
    public String getBranchBankNo() {
        return branchBankNo;
    }

    public void setBranchBankNo(String branchBankNo) {
        this.branchBankNo = branchBankNo;
    }
    public String getBankno() {
        return bankno;
    }

    public void setBankno(String bankno) {
        this.bankno = bankno;
    }
    public String getIsabroad() {
        return isabroad;
    }

    public void setIsabroad(String isabroad) {
        this.isabroad = isabroad;
    }
    public String getRegno() {
        return regno;
    }

    public void setRegno(String regno) {
        this.regno = regno;
    }
    public BigDecimal getAreaid() {
        return areaid;
    }

    public void setAreaid(BigDecimal areaid) {
        this.areaid = areaid;
    }
    public LocalDateTime getOpenaccountdate() {
        return openaccountdate;
    }

    public void setOpenaccountdate(LocalDateTime openaccountdate) {
        this.openaccountdate = openaccountdate;
    }
    public String getAccountno() {
        return accountno;
    }

    public void setAccountno(String accountno) {
        this.accountno = accountno;
    }
    public String getRealAccountno() {
        return realAccountno;
    }

    public void setRealAccountno(String realAccountno) {
        this.realAccountno = realAccountno;
    }
    public String getAccountname() {
        return accountname;
    }

    public void setAccountname(String accountname) {
        this.accountname = accountname;
    }
    public String getMemoryname() {
        return memoryname;
    }

    public void setMemoryname(String memoryname) {
        this.memoryname = memoryname;
    }
    public String getCurrencyno() {
        return currencyno;
    }

    public void setCurrencyno(String currencyno) {
        this.currencyno = currencyno;
    }
    public BigDecimal getUsageid() {
        return usageid;
    }

    public void setUsageid(BigDecimal usageid) {
        this.usageid = usageid;
    }
    public BigDecimal getCtid() {
        return ctid;
    }

    public void setCtid(BigDecimal ctid) {
        this.ctid = ctid;
    }
    public LocalDateTime getVaildstartdate() {
        return vaildstartdate;
    }

    public void setVaildstartdate(LocalDateTime vaildstartdate) {
        this.vaildstartdate = vaildstartdate;
    }
    public LocalDateTime getVaildenddate() {
        return vaildenddate;
    }

    public void setVaildenddate(LocalDateTime vaildenddate) {
        this.vaildenddate = vaildenddate;
    }
    public String getNatureid() {
        return natureid;
    }

    public void setNatureid(String natureid) {
        this.natureid = natureid;
    }
    public BigDecimal getForeigntype() {
        return foreigntype;
    }

    public void setForeigntype(BigDecimal foreigntype) {
        this.foreigntype = foreigntype;
    }
    public String getAssociateflag() {
        return associateflag;
    }

    public void setAssociateflag(String associateflag) {
        this.associateflag = associateflag;
    }
    public String getArrdess() {
        return arrdess;
    }

    public void setArrdess(String arrdess) {
        this.arrdess = arrdess;
    }
    public String getCnremark() {
        return cnremark;
    }

    public void setCnremark(String cnremark) {
        this.cnremark = cnremark;
    }
    public BigDecimal getIsSleep() {
        return isSleep;
    }

    public void setIsSleep(BigDecimal isSleep) {
        this.isSleep = isSleep;
    }
    public String getTempcode1() {
        return tempcode1;
    }

    public void setTempcode1(String tempcode1) {
        this.tempcode1 = tempcode1;
    }
    public String getTempcode2() {
        return tempcode2;
    }

    public void setTempcode2(String tempcode2) {
        this.tempcode2 = tempcode2;
    }
    public String getTempcode3() {
        return tempcode3;
    }

    public void setTempcode3(String tempcode3) {
        this.tempcode3 = tempcode3;
    }
    public String getTempcode4() {
        return tempcode4;
    }

    public void setTempcode4(String tempcode4) {
        this.tempcode4 = tempcode4;
    }
    public String getTempcode5() {
        return tempcode5;
    }

    public void setTempcode5(String tempcode5) {
        this.tempcode5 = tempcode5;
    }
    public String getTempcode6() {
        return tempcode6;
    }

    public void setTempcode6(String tempcode6) {
        this.tempcode6 = tempcode6;
    }
    public String getTempcode7() {
        return tempcode7;
    }

    public void setTempcode7(String tempcode7) {
        this.tempcode7 = tempcode7;
    }
    public String getTempcode8() {
        return tempcode8;
    }

    public void setTempcode8(String tempcode8) {
        this.tempcode8 = tempcode8;
    }
    public String getTempcode9() {
        return tempcode9;
    }

    public void setTempcode9(String tempcode9) {
        this.tempcode9 = tempcode9;
    }
    public String getTempcode10() {
        return tempcode10;
    }

    public void setTempcode10(String tempcode10) {
        this.tempcode10 = tempcode10;
    }
    public BigDecimal getAcntstate() {
        return acntstate;
    }

    public void setAcntstate(BigDecimal acntstate) {
        this.acntstate = acntstate;
    }
    public LocalDateTime getCanceldate() {
        return canceldate;
    }

    public void setCanceldate(LocalDateTime canceldate) {
        this.canceldate = canceldate;
    }
    public String getCancelremark() {
        return cancelremark;
    }

    public void setCancelremark(String cancelremark) {
        this.cancelremark = cancelremark;
    }
    public String getCancelreason() {
        return cancelreason;
    }

    public void setCancelreason(String cancelreason) {
        this.cancelreason = cancelreason;
    }
    public String getFileremark() {
        return fileremark;
    }

    public void setFileremark(String fileremark) {
        this.fileremark = fileremark;
    }
    public String getCreateuser() {
        return createuser;
    }

    public void setCreateuser(String createuser) {
        this.createuser = createuser;
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
    public BigDecimal getAvailableBalance() {
        return availableBalance;
    }

    public void setAvailableBalance(BigDecimal availableBalance) {
        this.availableBalance = availableBalance;
    }
    public BigDecimal getAccountBalance() {
        return accountBalance;
    }

    public void setAccountBalance(BigDecimal accountBalance) {
        this.accountBalance = accountBalance;
    }
    public String getEaccount() {
        return eaccount;
    }

    public void setEaccount(String eaccount) {
        this.eaccount = eaccount;
    }
    public String getPublicTelephone() {
        return publicTelephone;
    }

    public void setPublicTelephone(String publicTelephone) {
        this.publicTelephone = publicTelephone;
    }
    public String getCustomerManager() {
        return customerManager;
    }

    public void setCustomerManager(String customerManager) {
        this.customerManager = customerManager;
    }
    public String getCmTelephone() {
        return cmTelephone;
    }

    public void setCmTelephone(String cmTelephone) {
        this.cmTelephone = cmTelephone;
    }
    public String getCmMail() {
        return cmMail;
    }

    public void setCmMail(String cmMail) {
        this.cmMail = cmMail;
    }
    public LocalDateTime getRemovecanceldate() {
        return removecanceldate;
    }

    public void setRemovecanceldate(LocalDateTime removecanceldate) {
        this.removecanceldate = removecanceldate;
    }
    public String getRemovecancelreason() {
        return removecancelreason;
    }

    public void setRemovecancelreason(String removecancelreason) {
        this.removecancelreason = removecancelreason;
    }
    public BigDecimal getBeforecalcelstate() {
        return beforecalcelstate;
    }

    public void setBeforecalcelstate(BigDecimal beforecalcelstate) {
        this.beforecalcelstate = beforecalcelstate;
    }
    public BigDecimal getIsDeduct() {
        return isDeduct;
    }

    public void setIsDeduct(BigDecimal isDeduct) {
        this.isDeduct = isDeduct;
    }
    public BigDecimal getIsEscrowaccount() {
        return isEscrowaccount;
    }

    public void setIsEscrowaccount(BigDecimal isEscrowaccount) {
        this.isEscrowaccount = isEscrowaccount;
    }
    public BigDecimal getConnectType() {
        return connectType;
    }

    public void setConnectType(BigDecimal connectType) {
        this.connectType = connectType;
    }
    public String getClableNo() {
        return clableNo;
    }

    public void setClableNo(String clableNo) {
        this.clableNo = clableNo;
    }
    public String getIban() {
        return iban;
    }

    public void setIban(String iban) {
        this.iban = iban;
    }
    public String getAccountNameInEnglish() {
        return accountNameInEnglish;
    }

    public void setAccountNameInEnglish(String accountNameInEnglish) {
        this.accountNameInEnglish = accountNameInEnglish;
    }
    public BigDecimal getOutFlag() {
        return outFlag;
    }

    public void setOutFlag(BigDecimal outFlag) {
        this.outFlag = outFlag;
    }
    public BigDecimal getCashManageType() {
        return cashManageType;
    }

    public void setCashManageType(BigDecimal cashManageType) {
        this.cashManageType = cashManageType;
    }
    public Long getVaildNumber() {
        return vaildNumber;
    }

    public void setVaildNumber(Long vaildNumber) {
        this.vaildNumber = vaildNumber;
    }
    public BigDecimal getIsBillAccount() {
        return isBillAccount;
    }

    public void setIsBillAccount(BigDecimal isBillAccount) {
        this.isBillAccount = isBillAccount;
    }
    public String getBillAccountType() {
        return billAccountType;
    }

    public void setBillAccountType(String billAccountType) {
        this.billAccountType = billAccountType;
    }
    public BigDecimal getIsStampLegalPerson() {
        return isStampLegalPerson;
    }

    public void setIsStampLegalPerson(BigDecimal isStampLegalPerson) {
        this.isStampLegalPerson = isStampLegalPerson;
    }
    public String getAuthorizeName() {
        return authorizeName;
    }

    public void setAuthorizeName(String authorizeName) {
        this.authorizeName = authorizeName;
    }
    public String getAuthorizeNo() {
        return authorizeNo;
    }

    public void setAuthorizeNo(String authorizeNo) {
        this.authorizeNo = authorizeNo;
    }
    public String getLegalPersonName() {
        return legalPersonName;
    }

    public void setLegalPersonName(String legalPersonName) {
        this.legalPersonName = legalPersonName;
    }
    public String getLegalPersonNo() {
        return legalPersonNo;
    }

    public void setLegalPersonNo(String legalPersonNo) {
        this.legalPersonNo = legalPersonNo;
    }
    public String getPersonStampName() {
        return personStampName;
    }

    public void setPersonStampName(String personStampName) {
        this.personStampName = personStampName;
    }
    public String getMoneyStampName() {
        return moneyStampName;
    }

    public void setMoneyStampName(String moneyStampName) {
        this.moneyStampName = moneyStampName;
    }
    public String getPublicStampName() {
        return publicStampName;
    }

    public void setPublicStampName(String publicStampName) {
        this.publicStampName = publicStampName;
    }
    public String getFinacialCompanyStamp() {
        return finacialCompanyStamp;
    }

    public void setFinacialCompanyStamp(String finacialCompanyStamp) {
        this.finacialCompanyStamp = finacialCompanyStamp;
    }
    public BigDecimal getIsPaySecurity() {
        return isPaySecurity;
    }

    public void setIsPaySecurity(BigDecimal isPaySecurity) {
        this.isPaySecurity = isPaySecurity;
    }
    public String getMakeUkHolder() {
        return makeUkHolder;
    }

    public void setMakeUkHolder(String makeUkHolder) {
        this.makeUkHolder = makeUkHolder;
    }
    public String getCheckUkHolder() {
        return checkUkHolder;
    }

    public void setCheckUkHolder(String checkUkHolder) {
        this.checkUkHolder = checkUkHolder;
    }
    public String getBackAccountStamp() {
        return backAccountStamp;
    }

    public void setBackAccountStamp(String backAccountStamp) {
        this.backAccountStamp = backAccountStamp;
    }
    public BigDecimal getPaylimitsTrans() {
        return paylimitsTrans;
    }

    public void setPaylimitsTrans(BigDecimal paylimitsTrans) {
        this.paylimitsTrans = paylimitsTrans;
    }
    public BigDecimal getPaylimitsDay() {
        return paylimitsDay;
    }

    public void setPaylimitsDay(BigDecimal paylimitsDay) {
        this.paylimitsDay = paylimitsDay;
    }
    public BigDecimal getWithdrawlimitsTrans() {
        return withdrawlimitsTrans;
    }

    public void setWithdrawlimitsTrans(BigDecimal withdrawlimitsTrans) {
        this.withdrawlimitsTrans = withdrawlimitsTrans;
    }
    public BigDecimal getWithdrawlimitsDay() {
        return withdrawlimitsDay;
    }

    public void setWithdrawlimitsDay(BigDecimal withdrawlimitsDay) {
        this.withdrawlimitsDay = withdrawlimitsDay;
    }
    public BigDecimal getWithdrawlimitsMonth() {
        return withdrawlimitsMonth;
    }

    public void setWithdrawlimitsMonth(BigDecimal withdrawlimitsMonth) {
        this.withdrawlimitsMonth = withdrawlimitsMonth;
    }
    public String getAccountCharge() {
        return accountCharge;
    }

    public void setAccountCharge(String accountCharge) {
        this.accountCharge = accountCharge;
    }
    public String getApplyDepartment() {
        return applyDepartment;
    }

    public void setApplyDepartment(String applyDepartment) {
        this.applyDepartment = applyDepartment;
    }
    public String getApplier() {
        return applier;
    }

    public void setApplier(String applier) {
        this.applier = applier;
    }
    public BigDecimal getIsEtsys() {
        return isEtsys;
    }

    public void setIsEtsys(BigDecimal isEtsys) {
        this.isEtsys = isEtsys;
    }
    public BigDecimal getBankAccountNature() {
        return bankAccountNature;
    }

    public void setBankAccountNature(BigDecimal bankAccountNature) {
        this.bankAccountNature = bankAccountNature;
    }
    public BigDecimal getIsEbank() {
        return isEbank;
    }

    public void setIsEbank(BigDecimal isEbank) {
        this.isEbank = isEbank;
    }
    public BigDecimal getIsFts() {
        return isFts;
    }

    public void setIsFts(BigDecimal isFts) {
        this.isFts = isFts;
    }
    public String getFtsMain() {
        return ftsMain;
    }

    public void setFtsMain(String ftsMain) {
        this.ftsMain = ftsMain;
    }
    public LocalDateTime getEbankDate() {
        return ebankDate;
    }

    public void setEbankDate(LocalDateTime ebankDate) {
        this.ebankDate = ebankDate;
    }
    public BigDecimal getDepositType() {
        return depositType;
    }

    public void setDepositType(BigDecimal depositType) {
        this.depositType = depositType;
    }

    @Override
    public String toString() {
        return "AimsAccountDO{" +
            "accountid=" + accountid +
            ", applyid=" + applyid +
            ", accountcode=" + accountcode +
            ", cltno=" + cltno +
            ", assid=" + assid +
            ", branchBankNo=" + branchBankNo +
            ", bankno=" + bankno +
            ", isabroad=" + isabroad +
            ", regno=" + regno +
            ", areaid=" + areaid +
            ", openaccountdate=" + openaccountdate +
            ", accountno=" + accountno +
            ", realAccountno=" + realAccountno +
            ", accountname=" + accountname +
            ", memoryname=" + memoryname +
            ", currencyno=" + currencyno +
            ", usageid=" + usageid +
            ", ctid=" + ctid +
            ", vaildstartdate=" + vaildstartdate +
            ", vaildenddate=" + vaildenddate +
            ", natureid=" + natureid +
            ", foreigntype=" + foreigntype +
            ", associateflag=" + associateflag +
            ", arrdess=" + arrdess +
            ", cnremark=" + cnremark +
            ", isSleep=" + isSleep +
            ", tempcode1=" + tempcode1 +
            ", tempcode2=" + tempcode2 +
            ", tempcode3=" + tempcode3 +
            ", tempcode4=" + tempcode4 +
            ", tempcode5=" + tempcode5 +
            ", tempcode6=" + tempcode6 +
            ", tempcode7=" + tempcode7 +
            ", tempcode8=" + tempcode8 +
            ", tempcode9=" + tempcode9 +
            ", tempcode10=" + tempcode10 +
            ", acntstate=" + acntstate +
            ", canceldate=" + canceldate +
            ", cancelremark=" + cancelremark +
            ", cancelreason=" + cancelreason +
            ", fileremark=" + fileremark +
            ", createuser=" + createuser +
            ", createTime=" + createTime +
            ", updateTime=" + updateTime +
            ", availableBalance=" + availableBalance +
            ", accountBalance=" + accountBalance +
            ", eaccount=" + eaccount +
            ", publicTelephone=" + publicTelephone +
            ", customerManager=" + customerManager +
            ", cmTelephone=" + cmTelephone +
            ", cmMail=" + cmMail +
            ", removecanceldate=" + removecanceldate +
            ", removecancelreason=" + removecancelreason +
            ", beforecalcelstate=" + beforecalcelstate +
            ", isDeduct=" + isDeduct +
            ", isEscrowaccount=" + isEscrowaccount +
            ", connectType=" + connectType +
            ", clableNo=" + clableNo +
            ", iban=" + iban +
            ", accountNameInEnglish=" + accountNameInEnglish +
            ", outFlag=" + outFlag +
            ", cashManageType=" + cashManageType +
            ", vaildNumber=" + vaildNumber +
            ", isBillAccount=" + isBillAccount +
            ", billAccountType=" + billAccountType +
            ", isStampLegalPerson=" + isStampLegalPerson +
            ", authorizeName=" + authorizeName +
            ", authorizeNo=" + authorizeNo +
            ", legalPersonName=" + legalPersonName +
            ", legalPersonNo=" + legalPersonNo +
            ", personStampName=" + personStampName +
            ", moneyStampName=" + moneyStampName +
            ", publicStampName=" + publicStampName +
            ", finacialCompanyStamp=" + finacialCompanyStamp +
            ", isPaySecurity=" + isPaySecurity +
            ", makeUkHolder=" + makeUkHolder +
            ", checkUkHolder=" + checkUkHolder +
            ", backAccountStamp=" + backAccountStamp +
            ", paylimitsTrans=" + paylimitsTrans +
            ", paylimitsDay=" + paylimitsDay +
            ", withdrawlimitsTrans=" + withdrawlimitsTrans +
            ", withdrawlimitsDay=" + withdrawlimitsDay +
            ", withdrawlimitsMonth=" + withdrawlimitsMonth +
            ", accountCharge=" + accountCharge +
            ", applyDepartment=" + applyDepartment +
            ", applier=" + applier +
            ", isEtsys=" + isEtsys +
            ", bankAccountNature=" + bankAccountNature +
            ", isEbank=" + isEbank +
            ", isFts=" + isFts +
            ", ftsMain=" + ftsMain +
            ", ebankDate=" + ebankDate +
            ", depositType=" + depositType +
        "}";
    }
}
