package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.common.orm.annotation.NstcDataScope;
import com.nstc.gwms.entity.UmGuaranteeApply;
import com.nstc.gwms.entity.scope.GwmsUmGuaranteeApplyCommonScope;
import com.nstc.gwms.entity.view.UmGuaranteeApplyViewOf214;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface UmGuaranteeApplyMapper extends BaseMapper<UmGuaranteeApply> {

    @NstcDataScope(columnAlias = {"cust_no"}, columnMapping = {"\"unitNo\""})
    Page<UmGuaranteeApplyViewOf214> queryApplyListWithPage(@Param("page") Page page, @Param("scope") GwmsUmGuaranteeApplyCommonScope scope);

}
