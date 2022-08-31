package com.bgd.api.common.security.arithmetic.util;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.nstc.core.entity.scope.NsClientScope;
import com.nstc.core.entity.view.NsclientView;
import com.nstc.gwms.entity.GuaranteeUser;
import com.nstc.gwms.entity.UmGuaranteePledge;
import com.nstc.gwms.entity.UmGuaranteeUser;
import com.nstc.gwms.enums.IsCheckEnum;
import com.nstc.util.StringUtils;
import org.springframework.beans.BeanUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * <p>Title:</p>
 *
 * <p>Description:</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author fbb
 * @since：2020/12/9 15:05
 */
public class GuaranteeBizUtil {

    /**
     * @description 对比合同变更或修改后 集团内的担保人的差异 （新增，删除，修改）
     * @author fbb
     * @param: oldFmid
     * @param: newFmid
     * @return: java.util.Map<com.nstc.gwms.entity.UmGuaranteeUser, java.lang.String> newUmGuaranteeUser -->oldUmGuaranteeUser
     */
    public static Map<UmGuaranteeUser, UmGuaranteeUser> compareGuaranteeUser(Long oldFmid, Long newFmid) {
        HashMap<UmGuaranteeUser, UmGuaranteeUser> resultMap = new HashMap<>(8);
        //旧集团内担保人
        List<UmGuaranteeUser> oldUmGuaranteeUserList = GwmsSpringContextUtil.getServiceLocator().getUmGuaranteeUserService().list(Wrappers.<UmGuaranteeUser>lambdaQuery().eq(UmGuaranteeUser::getFmId, oldFmid));
        oldUmGuaranteeUserList = filterUserList(oldUmGuaranteeUserList);
        //新集团内担保人
        List<UmGuaranteeUser> newUmGuaranteeUserList = GwmsSpringContextUtil.getServiceLocator().getUmGuaranteeUserService().list(Wrappers.<UmGuaranteeUser>lambdaQuery().eq(UmGuaranteeUser::getFmId, newFmid));
        newUmGuaranteeUserList = filterUserList(newUmGuaranteeUserList);
        //担保人
        List<String> oldCltNoList = oldUmGuaranteeUserList.stream().map(user -> {
            return user.getCltNo();
        }).collect(Collectors.toList());
        List<String> newCltNoList = newUmGuaranteeUserList.stream().map(user -> {
            return user.getCltNo();
        }).collect(Collectors.toList());
        //并集
        List<String> unionCltNos = (List<String>) org.apache.commons.collections4.CollectionUtils.union(oldCltNoList, newCltNoList);
        for (String cltNo : unionCltNos) {
            UmGuaranteeUser oldUmGuaranteeUser = getUserByCltNo(cltNo, oldUmGuaranteeUserList) == null ? new UmGuaranteeUser() : getUserByCltNo(cltNo, oldUmGuaranteeUserList);
            UmGuaranteeUser newUmGuaranteeUser = getUserByCltNo(cltNo, newUmGuaranteeUserList) == null ? new UmGuaranteeUser() : getUserByCltNo(cltNo, newUmGuaranteeUserList);
            resultMap.put(newUmGuaranteeUser, oldUmGuaranteeUser);
        }
        return resultMap;
    }


    /**
     * @description 对比合同变更或修改后 集团内的担保人的差异 （新增，删除，修改）
     * @author fbb
     * @param: oldGuaranteeId
     * @param: nowUmGuaranteeUserList
     * @return: map newUmGuaranteeUser -->oldUmGuaranteeUser
     */
    public static Map<UmGuaranteeUser, UmGuaranteeUser> compareGuaranteeUser(Long oldGuaranteeId, List<UmGuaranteeUser> nowUmGuaranteeUserList) {
        HashMap<UmGuaranteeUser, UmGuaranteeUser> resultMap = new HashMap<>(8);
        //旧集团内担保人
        List<UmGuaranteeUser> oldUmGuaranteeUserList = new ArrayList<>();

        List<GuaranteeUser> oldGuaranteeUserList = GwmsSpringContextUtil.getServiceLocator().getGuaranteeUserService().list(Wrappers.<GuaranteeUser>lambdaQuery().eq(GuaranteeUser::getGuaranteeId, oldGuaranteeId));
        for (GuaranteeUser guaranteeUser : oldGuaranteeUserList) {
            UmGuaranteeUser umGuaranteeUser = new UmGuaranteeUser();
            BeanUtils.copyProperties(guaranteeUser, umGuaranteeUser);
            oldUmGuaranteeUserList.add(umGuaranteeUser);
        }
        oldUmGuaranteeUserList = filterUserList(oldUmGuaranteeUserList);

        //新集团内担保人
        nowUmGuaranteeUserList = filterUserList(nowUmGuaranteeUserList);

        //担保人
        List<String> oldCltNoList = oldUmGuaranteeUserList.stream().map(user -> {
            return user.getCltNo();
        }).collect(Collectors.toList());
        List<String> newCltNoList = nowUmGuaranteeUserList.stream().map(user -> {
            return user.getCltNo();
        }).collect(Collectors.toList());
        //并集
        List<String> unionCltNos = (List<String>) org.apache.commons.collections4.CollectionUtils.union(oldCltNoList, newCltNoList);
        for (String cltNo : unionCltNos) {
            UmGuaranteeUser oldUmGuaranteeUser = getUserByCltNo(cltNo, oldUmGuaranteeUserList) == null ? new UmGuaranteeUser() : getUserByCltNo(cltNo, oldUmGuaranteeUserList);
            UmGuaranteeUser newUmGuaranteeUser = getUserByCltNo(cltNo, nowUmGuaranteeUserList) == null ? new UmGuaranteeUser() : getUserByCltNo(cltNo, nowUmGuaranteeUserList);
            resultMap.put(newUmGuaranteeUser, oldUmGuaranteeUser);
        }
        return resultMap;
    }

    /**
     * @description 对比合同变更或修改后 押品的差异 （新增，删除，修改）
     * @author fbb
     * @param: oldFmid
     * @param: newFmid
     * @return: newUmGuaranteePledge-->oldUmGuaranteePledge
     */
    public static Map<UmGuaranteePledge, UmGuaranteePledge> compareGuaranteePledge(Long oldFmid, Long newFmid) {
        HashMap<UmGuaranteePledge, UmGuaranteePledge> resultMap = new HashMap<>(8);
        //旧押品列表
        List<UmGuaranteePledge> oldUmGuaranteePledgeList = GwmsSpringContextUtil.getServiceLocator().getUmGuaranteePledgeService().list(Wrappers.<UmGuaranteePledge>lambdaQuery().eq(UmGuaranteePledge::getFmId, oldFmid));
        //新押品列表
        List<UmGuaranteePledge> newUmGuaranteePledgeList = GwmsSpringContextUtil.getServiceLocator().getUmGuaranteePledgeService().list(Wrappers.<UmGuaranteePledge>lambdaQuery().eq(UmGuaranteePledge::getFmId, newFmid));
        //担保人
        List<Long> oldPledgeIdList = oldUmGuaranteePledgeList.stream().map(pledge -> {
            return pledge.getPledgeId();
        }).collect(Collectors.toList());
        List<Long> newPledgeIdList = newUmGuaranteePledgeList.stream().map(pledge -> {
            return pledge.getPledgeId();
        }).collect(Collectors.toList());
        //并集
        List<Long> unionPledgeIds = (List<Long>) org.apache.commons.collections4.CollectionUtils.union(oldPledgeIdList, newPledgeIdList);
        for (Long pledgeId : unionPledgeIds) {
            UmGuaranteePledge oldUmGuaranteePledge = getPledgeByPledgeId(pledgeId, oldUmGuaranteePledgeList) == null ? new UmGuaranteePledge() : getPledgeByPledgeId(pledgeId, oldUmGuaranteePledgeList);
            UmGuaranteePledge newUmGuaranteePledge = getPledgeByPledgeId(pledgeId, newUmGuaranteePledgeList) == null ? new UmGuaranteePledge() : getPledgeByPledgeId(pledgeId, newUmGuaranteePledgeList);
            resultMap.put(newUmGuaranteePledge, newUmGuaranteePledge);
        }
        return resultMap;
    }

    //list内查找UmGuaranteeUser
    public static UmGuaranteeUser getUserByCltNo(String cltNo, List<UmGuaranteeUser> list) {
        if (cltNo == null || list == null || list.isEmpty()) {
            return null;
        } else {
            for (UmGuaranteeUser umGuaranteeUser : list) {
                if (cltNo.equals(umGuaranteeUser.getCltNo())) {
                    return umGuaranteeUser;
                }
            }
        }
        return null;
    }

    //list内查找UmGuaranteePledge
    public static UmGuaranteePledge getPledgeByPledgeId(Long pledgeId, List<UmGuaranteePledge> list) {
        if (pledgeId == null || list == null || list.isEmpty()) {
            return null;
        } else {
            for (UmGuaranteePledge umGuaranteePledge : list) {
                if (pledgeId.equals(umGuaranteePledge.getPledgeId())) {
                    return umGuaranteePledge;
                }
            }
        }
        return null;
    }

    /**
     * 筛选集团内的存在账号的单位
     *
     * @param umGuaranteeUserList
     * @return
     */
    public static List<UmGuaranteeUser> filterUserList(List<UmGuaranteeUser> umGuaranteeUserList) {
        List<UmGuaranteeUser> newUmGuaranteeUserList = new ArrayList<>();
        for (UmGuaranteeUser umGuaranteeUser : umGuaranteeUserList) {
            //是否在集团内 in内,out外
            String isCheck = umGuaranteeUser.getIsCheck();
            //  担保人/被担保人
            String cltNo = umGuaranteeUser.getCltNo();

            //调用主数据查询单位,看集团内是否存在此单位,如果有 那么更改子担保的担保方式  例如质押担保->第三方质押担保 并存数据库
            NsClientScope nsclientScope = new NsClientScope();
            nsclientScope.setUnitNo(cltNo);
            NsclientView nsclientView = null;
            if (StringUtils.isNotEmpty(cltNo)) {
                nsclientView = GwmsSpringContextUtil.getServiceLocator().getMainDataService().getOneUnit(nsclientScope);
            }
            boolean isInGroup = (isCheck != null && isCheck != "" && IsCheckEnum.IN.getValue().equals(isCheck));
            //如果是集团内，且为集团内企业。生成子合同
            if (isInGroup && nsclientView != null) {
                newUmGuaranteeUserList.add(umGuaranteeUser);
            }
        }
        return newUmGuaranteeUserList;
    }
}
