package com.bgd.api.common.security.arithmetic.util;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class JsonDateSerializer extends JsonSerializer<Date> {

    private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public JsonDateSerializer() {
    }

    public void serialize(Date value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        String stringDate = this.format.format(value);
        gen.writeString(stringDate);
    }
}
