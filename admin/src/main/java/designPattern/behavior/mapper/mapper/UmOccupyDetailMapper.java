package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.UmOccupyDetail;
import com.nstc.gwms.entity.scope.GwmsUmOccupyDetailScope;
import com.nstc.gwms.entity.view.GwmsUmOccupyDetailCommonView;
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
public interface UmOccupyDetailMapper extends BaseMapper<UmOccupyDetail> {

    List<GwmsUmOccupyDetailCommonView> query(@Param("scope") GwmsUmOccupyDetailScope umOccupyDetailScope);
}
