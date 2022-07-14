package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.GuaranteeLog;
import com.nstc.gwms.entity.scope.GwmsGuaranteeLogScope;
import com.nstc.gwms.entity.view.GwmsGuaranteeLogView;
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
public interface GuaranteeLogMapper extends BaseMapper<GuaranteeLog> {

    List<GuaranteeLog> getGuranteeLog(Integer contractId);

    /**
     * 查询担保黑瞳日志列表
     *
     * @param scope
     * @return
     */
    public List<GwmsGuaranteeLogView> queryGuaranteeLogList(@Param("scope") GwmsGuaranteeLogScope scope);
}
