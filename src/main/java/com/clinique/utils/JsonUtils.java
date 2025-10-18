package com.clinique.utils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

public class JsonUtils {

    public static String toJson(Object object) {
        if (object == null) {
            return "null";
        }

        if (object instanceof Map) {
            return mapToJson((Map<?, ?>) object);
        }

        if (object instanceof String) {
            return "\"" + escapeString((String) object) + "\"";
        }

        if (object instanceof Number || object instanceof Boolean) {
            return object.toString();
        }

        if (object instanceof LocalDate) {
            LocalDate date = (LocalDate) object;
            return "\"" + date.format(DateTimeFormatter.ISO_DATE) + "\"";
        }

        if (object instanceof LocalTime) {
            LocalTime time = (LocalTime) object;
            return "\"" + time.format(DateTimeFormatter.ISO_TIME) + "\"";
        }

        if (object instanceof LocalDateTime) {
            LocalDateTime dateTime = (LocalDateTime) object;
            return "\"" + dateTime.format(DateTimeFormatter.ISO_DATE_TIME) + "\"";
        }

        return "\"" + escapeString(object.toString()) + "\"";
    }

    private static String mapToJson(Map<?, ?> map) {
        if (map.isEmpty()) {
            return "{}";
        }

        StringBuilder sb = new StringBuilder();
        sb.append("{");

        boolean first = true;
        for (Map.Entry<?, ?> entry : map.entrySet()) {
            if (!first) {
                sb.append(",");
            }
            first = false;

            sb.append("\"").append(escapeString(entry.getKey().toString())).append("\":");
            sb.append(toJson(entry.getValue()));
        }

        sb.append("}");
        return sb.toString();
    }

    private static String escapeString(String string) {
        return string.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

}