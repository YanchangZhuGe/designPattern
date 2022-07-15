package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.gwms.entity.GwmsFeesPlan;
import com.nstc.gwms.entity.scope.GwmsFeesPlanRelationScope;
import com.nstc.gwms.entity.scope.GwmsFeesPlanSyncScope;
import com.nstc.gwms.entity.scope.GwmsFeesPlanWithPageScope;
import com.nstc.gwms.entity.scope.GwmsStatisticsFeesPlanScope;
import com.nstc.gwms.entity.view.GwmsFeesPlanManagementViewOf234;
import com.nstc.gwms.entity.view.GwmsFeesPlanRelationGuaranteeView;
import com.nstc.gwms.entity.view.GwmsFeesPlanSyncView;
import com.nstc.gwms.entity.view.GwmsFeesPlanView;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 * 担保费用计划 Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2022-06-02
 */
public interface GwmsFeesPlanMapper extends BaseMapper<GwmsFeesPlan> {

    Page<GwmsFeesPlanView> selectFeesPlanWithPage(@Param("page") Page page, @Param("scope") GwmsFeesPlanWithPageScope scope);

    GwmsFeesPlanManagementViewOf234 statisticsFeesPlan(GwmsStatisticsFeesPlanScope scope);

    /**
     * 获取当前前缀的递增序号
     *
     * @param prefix
     * @return
     */
    Integer selectCurrentPlanNo(@Param("prefix") String prefix);

    /**
     * 递增该前缀的序号
     *
     * @param prefix
     */
    void incrementFeesPlanNo(@Param("prefix") String prefix);


    List<GwmsFeesPlanRelationGuaranteeView> selectFeesPlansRelationGuarantee(@Param("scope") GwmsFeesPlanRelationScope scope);

    /**
     * 查询需要同步给融资的保费计划(由于同步的查询有比较多的固定逻辑，所以查询单独写)
     *
     * @param page
     * @param scope
     * @return
     */
    Page<GwmsFeesPlanSyncView> queryFeesPlanForSync(@Param("page") Page page, @Param("scope") GwmsFeesPlanSyncScope scope);
}
