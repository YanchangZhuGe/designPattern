package com.nstc.brs.business.query;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.BrsCheckRecord;
import com.nstc.brs.model.scope.MonthCheckScope;
import com.nstc.framework.web.util.FrameworkUtil;
import com.nstc.util.*;

import java.util.*;

/**
 * 月末对账列表
 *
 * @ClassName QueryMonthCheckListBusiness
 * @Author fmh
 * @Date 2024-11-22
 */
public class SelectCheckUserBusiness extends AbstractBRSBusiness {
    private Map<String, Object> brs_selectCheckUser_q;
    private List<Map<String, Object>> brs_selectCheckUser_l;

    @SuppressWarnings("unchecked")
    @Override
    public void doExecute() throws Exception {
        if (brs_selectCheckUser_q == null) {
            brs_selectCheckUser_q = new HashMap<String, Object>();
        }
        brs_selectCheckUser_q.put("notUserNo", FrameworkUtil.getProfile().getUserNo()); 
        brs_selectCheckUser_l = this.getContext().getAccountService().getCheckUser(brs_selectCheckUser_q);
        
        this.putResult("brs_selectCheckUser_q", brs_selectCheckUser_q);
        this.putResult("brs_selectCheckUser_l", brs_selectCheckUser_l);
    }

    public Map<String, Object> getBrs_selectCheckUser_q() {
        return brs_selectCheckUser_q;
    }

    public void setBrs_selectCheckUser_q(Map<String, Object> brs_selectCheckUser_q) {
        this.brs_selectCheckUser_q = brs_selectCheckUser_q;
    }

    public List<Map<String, Object>> getBrs_selectCheckUser_l() {
        return brs_selectCheckUser_l;
    }

    public void setBrs_selectCheckUser_l(List<Map<String, Object>> brs_selectCheckUser_l) {
        this.brs_selectCheckUser_l = brs_selectCheckUser_l;
    }
}
