package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.UmGuarantee;
import com.nstc.gwms.entity.scope.CountScope;
import com.nstc.gwms.entity.scope.UmGuaranteeScope;
import com.nstc.gwms.entity.view.GuaranteeView;
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
public interface UmGuaranteeMapper extends BaseMapper<UmGuarantee> {

    GuaranteeView queryUmGuarantee(@Param("scope") UmGuaranteeScope scope);

    Integer queryUmGuaranteeCount(CountScope scope);


    int getIsInFlowCount(@Param("guaranteeId") Long guaranteeId, @Param("guaranteeNo") String guaranteeNo, @Param("fmCls") List<String> fmCls, @Param("states") Integer[] states);
}
