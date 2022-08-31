package com.bgd.api.common.security.arithmetic.util;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.google.common.base.Strings;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Logger;

public class JsonDateDeserialize extends JsonDeserializer<Date> {

    private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public JsonDateDeserialize() {
    }

    public Date deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        String stringDate = p.getText();
        if (!Strings.isNullOrEmpty(stringDate)) {
            try {
                return this.format.parse(stringDate);
            } catch (ParseException var5) {
                Logger.getLogger(JsonDateDeserialize.class.getName()).info("时间序列化为Date失败");
                return null;
            }
        } else {
            return null;
        }
    }
}
