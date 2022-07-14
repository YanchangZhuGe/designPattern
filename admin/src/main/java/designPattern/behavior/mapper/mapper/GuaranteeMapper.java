package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.common.orm.annotation.NstcDataScope;
import com.nstc.gwms.entity.Guarantee;
import com.nstc.gwms.entity.Ledger;
import com.nstc.gwms.entity.scope.GuaranteeAmountCommonScope;
import com.nstc.gwms.entity.scope.GuaranteeScope;
import com.nstc.gwms.entity.scope.GwmsBussContractScopeOf241;
import com.nstc.gwms.entity.view.GuaranteeAmountCommonView;
import com.nstc.gwms.entity.view.GuaranteeLedgerView;
import com.nstc.gwms.entity.view.GuaranteePledgeView;
import com.nstc.gwms.entity.view.GuaranteeView;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface GuaranteeMapper extends BaseMapper<Guarantee> {

    List<GuaranteePledgeView> queryDocGuaranteePledger(Long wbId);

    Page<GuaranteeView> queryGuaranteeByScope(@Param("page") Page page, @Param("scope") GuaranteeScope scope);

    @NstcDataScope(columnAlias = {"cust_no"}, columnMapping = {"\"cltNo\""})
    Page<GuaranteeView> queryGuaranteeByScopeAuth(@Param("page") Page page, @Param("scope") GuaranteeScope scope);

    GuaranteeView queryGuaranteeAmount(@Param("scope") GuaranteeScope scope);

    Long queryGuaranteeIdByGuarId(Long guaranteeId);

    GuaranteeView queryGuaranteeById(Long guaranteeId);

    Map<String, Object> queryGuaranteeUseAmount(Map<String, Object> queryMap);

    List<GuaranteeAmountCommonView> queryGuaranteeAmountCommon(@Param("scope") GuaranteeAmountCommonScope guaranteeAmountCommonScope);

    GuaranteeView getGuarantee(Long destguaranteeId);

    //GuaranteeLedgerView queryLedgerForReplace(@Param("scope") GuaranteeLedgerScope releaseLedger);

    void syncReplaceGuarantee(Ledger guaranteeLedger);

    List<GuaranteeLedgerView> queryUmReplaceGuaranteeByLedger(@Param("scope") GuaranteeLedgerView ledger);

    GuaranteeLedgerView queryLedgerForReplace(@Param("bussNo") String bussNo, @Param("originalGuaranteeId") Long originalGuaranteeId, @Param("replaceGuaranteeId") Long replaceGuaranteeId, @Param("bussType") String bussType);

    void updateByNormal(@Param("scope") Guarantee guarant);

    Page queryBussContract(@Param("page") Page page, @Param("scope") GwmsBussContractScopeOf241 scope);
}
