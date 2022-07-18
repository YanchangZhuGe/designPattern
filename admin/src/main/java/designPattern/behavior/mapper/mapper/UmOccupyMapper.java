package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.UmOccupy;
import com.nstc.gwms.entity.scope.CountScope;
import com.nstc.gwms.entity.scope.UmOccupyScope;
import com.nstc.gwms.entity.view.UmOccupyView;
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
public interface UmOccupyMapper extends BaseMapper<UmOccupy> {

    List<UmOccupyView> queryUmGuaranteeOccupy(@Param("scope") UmOccupyScope scope);

    Integer queryUmGuaranteeOccupyCount(CountScope countScope);

}
