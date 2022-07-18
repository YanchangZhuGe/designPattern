package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.LedgerDetail;

/**
 * <p>
 * 多币种占用详情 Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface LedgerDetailMapper extends BaseMapper<LedgerDetail> {
    /**
     * 查询金额占用详情 查询金额占用详情
     *
     * @param detail
     * @return
     */
    LedgerDetail queryLedgerDetail(LedgerDetail detail);

}
