package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.gwms.entity.FeesPay;
import com.nstc.gwms.entity.scope.GwmsFeesPayScope;
import com.nstc.gwms.entity.view.GwmsFeesPayView;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * 已付保费记录 Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface GwmsFeesPayMapper extends BaseMapper<FeesPay> {

    Page<GwmsFeesPayView> queryGwmsFeesPayWithPage(@Param("page") Page page, @Param("scope") GwmsFeesPayScope scope);

}
