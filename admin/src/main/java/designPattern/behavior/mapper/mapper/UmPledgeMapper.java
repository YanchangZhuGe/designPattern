package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.UmPledge;
import com.nstc.gwms.entity.view.UmPledgeView;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface UmPledgeMapper extends BaseMapper<UmPledge> {

    public UmPledgeView queryDetailUm(Long fmId);
}
