package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.Ledger;
import com.nstc.gwms.entity.scope.GuarantorNoScope;
import com.nstc.gwms.entity.scope.LedgerListScope;
import com.nstc.gwms.entity.scope.LedgerScope;
import com.nstc.gwms.entity.view.LedgerBussOccpuyView;
import com.nstc.gwms.entity.view.LedgerInitView;
import com.nstc.gwms.entity.view.OccupyDetailView;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface LedgerMapper extends BaseMapper<Ledger> {

    List<LedgerBussOccpuyView> queryBussOccpuy(LedgerScope scope);

    List<OccupyDetailView> queryBussOccpuyDetail(@Param("req") GuarantorNoScope scope);

    List<LedgerInitView> queryInitLedgerList(@Param("req") LedgerListScope scope);
}
