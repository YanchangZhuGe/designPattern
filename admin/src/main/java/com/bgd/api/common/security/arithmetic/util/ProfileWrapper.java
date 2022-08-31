package com.bgd.api.common.security.arithmetic.util;

import com.nstc.common.entity.core.Profile;
import org.springframework.beans.BeanUtils;

public class ProfileWrapper extends Profile {

    private String rawToken;

    public ProfileWrapper() {
    }

    public static ProfileWrapper fromProfile(Profile p) {
        ProfileWrapper w = new ProfileWrapper();
        BeanUtils.copyProperties(p, w);
        return w;
    }

    public String getRawToken() {
        return this.rawToken;
    }

    public void setRawToken(String rawToken) {
        this.rawToken = rawToken;
    }
}
