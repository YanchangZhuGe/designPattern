package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.UmFmAttach;

import java.util.List;

/**
 * <p>
 * 担保合同替换工单表 Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface GwmsUmFmAttachMapper extends BaseMapper<UmFmAttach> {

    List<UmFmAttach> getUmFileByFmId(Long fmId);

    void deleteUmFileByFmId(Long fmId);

}
