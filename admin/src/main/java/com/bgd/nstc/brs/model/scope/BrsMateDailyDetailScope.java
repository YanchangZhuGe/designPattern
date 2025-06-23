package com.nstc.brs.model.scope;

import com.nstc.brs.domain.BrsMateDailyDetail;

import java.util.Date;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2024-11-27
 * @Version:1.0
 */
public class BrsMateDailyDetailScope extends BrsMateDailyDetail {

    private String bankAccountNo;
    private Double minAmount;
    private Double maxAmount;
    private Date startBookDate;
    private Date endBookDate;
    private String checkAccNoLike;
    private String[] sourceIdArray;

    public String[] getSourceIdArray() {
        return sourceIdArray;
    }

    public void setSourceIdArray(String[] sourceIdArray) {
        this.sourceIdArray = sourceIdArray;
    }

    public String getCheckAccNoLike() {
        return checkAccNoLike;
    }

    public void setCheckAccNoLike(String checkAccNoLike) {
        this.checkAccNoLike = checkAccNoLike;
    }

    public String getBankAccountNo() {
        return bankAccountNo;
    }

    public void setBankAccountNo(String bankAccountNo) {
        this.bankAccountNo = bankAccountNo;
    }

    public Double getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(Double minAmount) {
        this.minAmount = minAmount;
    }

    public Double getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(Double maxAmount) {
        this.maxAmount = maxAmount;
    }

    public Date getStartBookDate() {
        return startBookDate;
    }

    public void setStartBookDate(Date startBookDate) {
        this.startBookDate = startBookDate;
    }

    public Date getEndBookDate() {
        return endBookDate;
    }

    public void setEndBookDate(Date endBookDate) {
        this.endBookDate = endBookDate;
    }
}
