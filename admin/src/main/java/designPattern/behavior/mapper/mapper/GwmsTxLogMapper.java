package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.TxLog;
import com.nstc.gwms.entity.view.TxLogView;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 * 交易管理操作日志 Mapper 接口
 * </p>
 *
 * @author wk
 * @since 2021-1-12
 */
public interface GwmsTxLogMapper extends BaseMapper<TxLog> {
    /**
     * 根据货运单据查询单据操作日志
     *
     * @param sdId 单据ID
     * @return 操作日志
     */
    List<TxLogView> queryShippingDocumentLogsBySdId(@Param("sdId") Long sdId);
}
