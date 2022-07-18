package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.common.orm.annotation.NstcDataScope;
import com.nstc.gwms.entity.Pledge;
import com.nstc.gwms.entity.scope.PledgeScopeOf119;
import com.nstc.gwms.entity.view.GuaranteePledgeView;
import com.nstc.gwms.entity.view.PledgeView;
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
public interface PledgeMapper extends BaseMapper<Pledge> {
    List<PledgeView> queryGuaranteePledgeList(PledgeScopeOf119 gwmsGuaranteePledgeScope);

    List<GuaranteePledgeView> queryDeletePledge(Pledge pledge);

    @NstcDataScope(columnAlias = {"cust_no"}, columnMapping = {"\"cltNo\""})
    Page<PledgeView> queryPledgeWithPage(@Param("page") Page page, @Param("scope") PledgeScopeOf119 pledgeScope);
}
