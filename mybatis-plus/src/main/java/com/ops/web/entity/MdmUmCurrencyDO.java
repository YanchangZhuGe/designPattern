package com.ops.web.entity;

import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;

/**
 * <p>
 *
 * </p>
 *
 * @author wyc
 * @since 2022-07-05
 */
@TableName("MDM_UM_CURRENCY")
public class MdmUmCurrencyDO {

    /**
     * 流水号
     */
    private BigDecimal id;

    /**
     * 国际代码
     */
    private String codeno;

    /**
     * 中文名称
     */
    private String codename;

    /**
     * 币种类型 0－本位币(人民币);1－基准外币（美元）;2－其它
     */
    private BigDecimal currencytype;

    /**
     * 英文名称
     */
    private String englisname;

    /**
     * 货币符号
     */
    private String symbol;

    /**
     * 国家名称
     */
    private String countryname;

    private BigDecimal isenable;

    /**
     * 排列顺序
     */
    private BigDecimal codeorder;

    private String languageCode;

    private String sourcekey;

    private String currencyUnit;

    /**
     * 货币基础单位(英文)
     */
    private String currencyUnitEn;

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public String getCodeno() {
        return codeno;
    }

    public void setCodeno(String codeno) {
        this.codeno = codeno;
    }

    public String getCodename() {
        return codename;
    }

    public void setCodename(String codename) {
        this.codename = codename;
    }

    public BigDecimal getCurrencytype() {
        return currencytype;
    }

    public void setCurrencytype(BigDecimal currencytype) {
        this.currencytype = currencytype;
    }

    public String getEnglisname() {
        return englisname;
    }

    public void setEnglisname(String englisname) {
        this.englisname = englisname;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getCountryname() {
        return countryname;
    }

    public void setCountryname(String countryname) {
        this.countryname = countryname;
    }

    public BigDecimal getIsenable() {
        return isenable;
    }

    public void setIsenable(BigDecimal isenable) {
        this.isenable = isenable;
    }

    public BigDecimal getCodeorder() {
        return codeorder;
    }

    public void setCodeorder(BigDecimal codeorder) {
        this.codeorder = codeorder;
    }

    public String getLanguageCode() {
        return languageCode;
    }

    public void setLanguageCode(String languageCode) {
        this.languageCode = languageCode;
    }

    public String getSourcekey() {
        return sourcekey;
    }

    public void setSourcekey(String sourcekey) {
        this.sourcekey = sourcekey;
    }

    public String getCurrencyUnit() {
        return currencyUnit;
    }

    public void setCurrencyUnit(String currencyUnit) {
        this.currencyUnit = currencyUnit;
    }

    public String getCurrencyUnitEn() {
        return currencyUnitEn;
    }

    public void setCurrencyUnitEn(String currencyUnitEn) {
        this.currencyUnitEn = currencyUnitEn;
    }

    @Override
    public String toString() {
        return "MdmUmCurrencyDO{" +
                "id=" + id +
                ", codeno=" + codeno +
                ", codename=" + codename +
                ", currencytype=" + currencytype +
                ", englisname=" + englisname +
                ", symbol=" + symbol +
                ", countryname=" + countryname +
                ", isenable=" + isenable +
                ", codeorder=" + codeorder +
                ", languageCode=" + languageCode +
                ", sourcekey=" + sourcekey +
                ", currencyUnit=" + currencyUnit +
                ", currencyUnitEn=" + currencyUnitEn +
                "}";
    }
}
