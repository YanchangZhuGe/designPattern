package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.gwms.entity.Param;
import com.nstc.gwms.entity.scope.ParamCalcWayCommonScope;
import com.nstc.gwms.entity.scope.ParamQueryScope;
import com.nstc.gwms.entity.view.ParamCalcWayBankView;
import com.nstc.gwms.entity.view.ParamCalcWayCommonView;
import com.nstc.gwms.entity.view.ParamView;

import java.util.List;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface GwmsParamMapper extends BaseMapper<Param> {

    List<ParamView> getParamList(ParamQueryScope scope);

    List<ParamCalcWayCommonView> getQuotaCalcWayOfCommon(ParamCalcWayCommonScope scope);

    List<ParamCalcWayBankView> getQuotaCalcWayOfBank();

    void saveParam(Param param);

    void updateParam(Param param);

    void updateCalcWayOfCommon(ParamCalcWayCommonScope calcWayCommonScope);

    /**
     * 担保设置参数查询（分页）
     *
     * @param page
     * @param paramQueryScope
     * @return
     */
    Page<ParamView> getParamListWithPage(@org.apache.ibatis.annotations.Param("page") Page page,
                                         @org.apache.ibatis.annotations.Param("scope") ParamQueryScope paramQueryScope);
}
