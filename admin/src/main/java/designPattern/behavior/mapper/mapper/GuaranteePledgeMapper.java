package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.GuaranteePledge;
import com.nstc.gwms.entity.view.GuaranteePledgeView;

import java.util.List;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface GuaranteePledgeMapper extends BaseMapper<GuaranteePledge> {

    List<GuaranteePledgeView> queryGuaranteePledge(Long fmId);

    /**
     * @param gPledgeId : 抵押ID
     * @return : 押物信息
     * @Description:获得质押物信息
     */
    List<GuaranteePledgeView> getGuaranteePledge(Long gPledgeId);
}
