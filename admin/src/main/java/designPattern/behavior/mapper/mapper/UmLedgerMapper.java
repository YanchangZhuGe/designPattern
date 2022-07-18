package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.UmLedger;
import com.nstc.gwms.entity.scope.CountScope;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface UmLedgerMapper extends BaseMapper<UmLedger> {

    Integer queryUmLedgerCount(CountScope countScope);

}
