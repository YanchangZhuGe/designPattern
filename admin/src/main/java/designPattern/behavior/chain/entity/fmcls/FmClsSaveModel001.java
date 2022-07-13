package designPattern.behavior.chain.entity.fmcls;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

@Data
public class FmClsSaveModel001 extends SaveModel {

    private String flowFlag;

    private UmGuaranteeApply umGuaranteeApply;

    private List<UmGuaranteeapplayUser> umGuaranteeApplyUserList;

    private List<UmGuaranteeApplyPledge> umGuaranteeApplyPledgeList;
    @ApiModelProperty("电子档案")
    private List<GwmsEamsFileScope> gwmsEamsFileScopes;

}
