package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.nstc.gwms.entity.UmFmLog;
import com.nstc.gwms.entity.scope.GwmsUmFmLogScope;
import com.nstc.gwms.entity.view.GwmsUmFmLogView;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * <p>Title:工单日志 Mapper 接口</p>
 *
 * <p>Description:工单日志 Mapper 接口</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tangjiagang
 * @version 1.0
 * @since：2020/10/30 10:25
 */
public interface GwmsUmFmLogMapper extends BaseMapper<UmFmLog> {

    /**
     * 保存工单日志，严禁使用了（该方法使用um_fm_log_seq序列，目前新G6看起来只是用了SEQ_PK_UM_FM_LOG）
     *
     * @param log
     */
    @Deprecated
    void saveUmFmLog(UmFmLog log);

    Date selectMinLogDate(Long fmId);

    Integer queryCustomizedSystemsValue();

    List<UmFmLog> getUmFmLog(Long fmId);

    /**
     * 查询工单日志列表
     *
     * @param page
     * @param scope
     * @return
     */
    Page<GwmsUmFmLogView> queryList(@Param("page") Page<?> page, @Param("scope") GwmsUmFmLogScope scope);
}
