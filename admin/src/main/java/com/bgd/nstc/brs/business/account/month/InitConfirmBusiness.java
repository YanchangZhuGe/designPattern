package com.nstc.brs.business.account.month;

import com.nstc.brs.business.AbstractBRSBusiness;
import com.nstc.brs.domain.scope.RecordCommonScope;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author:YPQ
 * @CreateTime: 2025-03-19
 * @Version:1.0
 */
public class InitConfirmBusiness extends AbstractBRSBusiness {
     private String okList;
     private String detailData;

    @Override
    public void doExecute() throws Exception {
        System.out.println("==================InitConfirmBusiness====="+okList);
        System.out.println("==============InitConfirmBusiness====detailData====="+detailData);
        String[] idArray = okList.split(",");
        RecordCommonScope scope = new RecordCommonScope();
        scope.setIdArray(idArray);
        List<Map<String,Object>> dataList = getContext().getCommonService().getInnerRecordList(scope);
        this.putResult("brs_comfirm_list", dataList);
        this.putResult("detailData", detailData);

    }

    public String getOkList() {
        return okList;
    }

    public void setOkList(String okList) {
        this.okList = okList;
    }

    public String getDetailData() {
        return detailData;
    }

    public void setDetailData(String detailData) {
        this.detailData = detailData;
    }
}
