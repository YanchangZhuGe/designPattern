package designPattern.behavior.mapper.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nstc.gwms.entity.UmFmAttach;
import com.nstc.gwms.entity.UmForm;

import java.util.List;
import java.util.Map;

/**
 * <p>Title:工单 Mapper 接口</p>
 *
 * <p>Description:工单 Mapper 接口</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author tangjiagang
 * @version 1.0
 * @since：2020/10/30 10:25
 */
public interface GwmsUmFormMapper extends BaseMapper<UmForm> {
    /**
     * @param umForm
     * @param @return
     * @return
     * @throws
     * @Description: 保存工单信息
     */
    Integer saveUmForm(UmForm umForm);

    /**
     * @param umForm
     * @Description：修改工单信息
     * @author huangjun
     * @since：2020/10/30 10:48
     */
    Integer updateUmForm(UmForm umForm);

    void saveUmFmAttach(UmFmAttach file);

    void deleteUmFmAttach(Long fmId);

    List<Map<String, Object>> getBizFlow(Map<String, Object> map);

    /**
     * 根据工作流编号前缀获取流水号
     *
     * @param bizNoPrefix 编号前缀
     * @return 流水号
     */
    String getBizNoSequenceNo(String bizNoPrefix);

//    List<UmForm> querybizFmClsforRegister(UmFormScope scope);
//
//    List<UmForm> querybizFmClsforApply(UmFormScope scope);
//    /**
//     * 根据工作流编号前缀获取流水号
//     * @param bizNoPrefix 编号前缀
//     * @return 流水号
//     */
}
