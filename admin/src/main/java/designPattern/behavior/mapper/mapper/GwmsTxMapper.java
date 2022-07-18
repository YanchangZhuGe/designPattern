package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.Tx;
import com.nstc.gwms.entity.scope.TxScope;
import com.nstc.gwms.entity.view.TxView;

import java.util.List;

/**
 * <p>
 * 交易信息表 Mapper 接口
 * </p>
 *
 * @author wk
 * @since 2021-1-12
 */
public interface GwmsTxMapper extends BaseMapper<Tx> {
    /**
     * 查询交易表信息
     *
     * @param sdTxScope
     * @return
     */
    List<TxView> queryTxByScope(TxScope sdTxScope);

    /**
     * 根据txId修改交易表信息
     *
     * @param tx
     */
    void updateTxByModel(Tx tx);

}
