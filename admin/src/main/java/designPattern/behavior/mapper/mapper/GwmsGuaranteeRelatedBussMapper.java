package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.GwmsGuaranteeRelatedBuss;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-08-03
 */
public interface GwmsGuaranteeRelatedBussMapper extends BaseMapper<GwmsGuaranteeRelatedBuss> {

    /**
     * 根据担保合同ID，关联业务类型，关联业务ID删除担保合同的关联业务信息
     *
     * @param buss
     */
    public void deleteByCondition(@Param("scope") GwmsGuaranteeRelatedBuss buss);
}
