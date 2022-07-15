package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.File;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Set;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author chenyuhao
 * @since 2021-04-12
 */
public interface GwmsFileMapper extends BaseMapper<File> {

    List<File> queryGWMSFile(@Param("contractId") Long contractId, @Param("type") String type);

    void deleteFileByBid(@Param(value = "bid") Long bid, @Param("type") String type);

    List<File> selectFileList(@Param(value = "bidList") Set<Long> bidList, @Param("type") String type);
}
