package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.gwms.entity.GwmsFeesPlanLog;
import com.nstc.gwms.entity.scope.GwmsFeesPlanLogScope;
import com.nstc.gwms.entity.view.GwmsFeesPlanLogView;
import org.apache.ibatis.annotations.Param;

/**
 * 保费计划日志
 */
public interface GwmsFeesPlanLogMapper extends BaseMapper<GwmsFeesPlanLog> {

    Page<GwmsFeesPlanLogView> queryGwmsFeesPlanLogWithPage(@Param("page") Page page, @Param("scope") GwmsFeesPlanLogScope scope);


}