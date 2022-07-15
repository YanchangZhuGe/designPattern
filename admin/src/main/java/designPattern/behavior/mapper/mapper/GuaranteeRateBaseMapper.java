package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.GuaranteeRateBase;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface GuaranteeRateBaseMapper extends BaseMapper<GuaranteeRateBase> {

    Double getRateByCode(@Param("standardNo") String standardNo, @Param("targetNo") String targetNo);
}
