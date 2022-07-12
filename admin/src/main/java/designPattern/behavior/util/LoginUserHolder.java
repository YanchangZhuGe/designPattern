package designPattern.behavior.util;

import cn.hutool.core.codec.Base64;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.nstc.neams.api.LoginUserDTO;
import com.nstc.neams.api.PubServiceApi;
import com.nstc.neams.model.dto.ResultVo;
import com.nstc.neams.model.dto.UserDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.nio.charset.Charset;
import java.util.HashMap;

@Slf4j
@Component
public class LoginUserHolder {

    private static PubServiceApi pubServiceApi = null;

    public LoginUserHolder(PubServiceApi pubServiceApiArg) {
        pubServiceApi = pubServiceApiArg;
    }

    public static UserDTO getCurrentUser() {
        RequestAttributes request = RequestContextHolder.getRequestAttributes();
        if (request != null && request.getAttribute("userDto", 0) != null) {
            return (UserDTO) request.getAttribute("userDto", 0);
        } else {
            UserDTO uDto = new UserDTO();
            uDto.setUserNo("jz");
            uDto.setUserName("机制");
            try {
                ResultVo<LoginUserDTO> loginUserDTO = pubServiceApi.getUserInfo();
                if (loginUserDTO.getResult() != null) {
                    uDto.setUserId(((LoginUserDTO) loginUserDTO.getResult()).getId());
                    uDto.setUserNo(((LoginUserDTO) loginUserDTO.getResult()).getUserCode());
                    uDto.setUserName(((LoginUserDTO) loginUserDTO.getResult()).getUserName());
                    uDto.setCustNo(((LoginUserDTO) loginUserDTO.getResult()).getCurrentCompanySegment());
                    uDto.setCustName((String) null);
                    uDto.setCustTreeNo(((LoginUserDTO) loginUserDTO.getResult()).getHierarchyCode());
                    if (request != null) {
                        request.setAttribute("userDto", uDto, 0);
                    }
                }
                return uDto;
            } catch (Exception e) {
                log.error("获取登录用户", e.getMessage());
                return getSGCWUserInfo(uDto);
            }
        }
    }

    /**
     * 获取首钢当前登录人
     *
     * @param uDto
     * @return
     */
    public static UserDTO getSGCWUserInfo(UserDTO uDto) {
        ServletRequestAttributes servletRequestAttributes =
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (null == servletRequestAttributes) {
            return uDto;
        }
        HttpServletRequest request = servletRequestAttributes.getRequest();
        String userStr = request.getHeader("x-client-token-user");
        if (StringUtils.isNotBlank(userStr)) {
            return uDto;
        }
        String json = Base64.decodeStr(userStr, Charset.forName("UTF-8"));
        log.info("x-token:" + userStr);
        JSONObject jsonObject = JSON.parseObject(json);
        HashMap uMap = (HashMap) JSON.parseObject(jsonObject.getString("user_name"), HashMap.class);
        String userNo = (String) uMap.get("userNo");
        String userName = (String) uMap.get("userName");
        if (StringUtils.isNotBlank(userNo) && StringUtils.isNotBlank(userName)) {
            uDto.setUserNo(userNo);
            uDto.setUserName(userName);
        }
        return uDto;
    }
}
