package com.betopia.hrm.cdc_data_pipeline.consumers;

import com.betopia.hrm.cdc_data_pipeline.domain.models.Payload;
import com.betopia.hrm.cdc_data_pipeline.domain.models.Root;
import com.betopia.hrm.cdc_data_pipeline.request.Message;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class AttendanceConsumer {

    @Value("${enable.hard.delete.all}")
    private boolean enableCdcHardDeleteAll;

    private static final Logger LOG = LoggerFactory.getLogger(AttendanceConsumer.class);

    private final JdbcTemplate jdbcTemplate;
    private final DataSource dataSource;

    public AttendanceConsumer(JdbcTemplate jdbcTemplate, DataSource dataSource) {
        this.jdbcTemplate = jdbcTemplate;
        this.dataSource = dataSource;
    }

    /** Schema change listener (not used yet) **/
    @KafkaListener(topics = {"${topic.schema.ddl}"}, concurrency = "1")
    public void listenerSchema(ConsumerRecord<String, String> record, Acknowledgment ack) {
        String message = record.value();
        if (message == null) {
            LOG.info("Schema-Change Message received but was null.");
            return;
        }
        LOG.info("Schema-Change Message received.");
        try {
            LOG.info("topic.schema.ddl: not implemented yet.");
            ack.acknowledge();
        } catch (Exception e) {
            LOG.error("Schema listener error: ", e);
        }
    }

    /** Attendance CDC Listener **/
    @KafkaListener(topics = {"${topic.schema.attendance}"}, concurrency = "1")
    public void listenerAttendance(ConsumerRecord<String, String> record, Acknowledgment ack) {
        String message = record.value();
        if (message == null) {
            LOG.info("Attendance-Change Message received but was null.");
            return;
        }
        LOG.info("Attendance-Change Message received.");

        try {
            Root root = Message.unmarshal(Root.class, message);
            Payload payload = root.getPayload();

            if (payload.getBefore() == null) {
                // Insert
                LOG.info("Inserting new attendance record");
                insertAttendance(payload.getAfter());
            } else if (payload.getAfter() == null) {
                // Delete
                if (enableCdcHardDeleteAll) {
                    LOG.info("Hard delete enabled. Deleting id={}", payload.getBefore().get("id"));
                    hardDelete((Integer) payload.getBefore().get("id"));
                } else {
                    LOG.info("Soft deleting id={}", payload.getBefore().get("id"));
                    softDelete((Integer) payload.getBefore().get("id"));
                }
            } else if (payload.getAfter() != null && payload.getBefore() != null) {
                // Update
                if (payload.getAfter().get("deleted_at") == null) {
                    LOG.info("Updating attendance record id={}", payload.getAfter().get("id"));
                    updateAttendance(payload.getAfter());
                } else {
                    LOG.info("Soft deleting id={}", payload.getAfter().get("id"));
                    softDelete((Integer) payload.getAfter().get("id"));
                }
            } else {
                LOG.warn("Unexpected payload structure: {}", payload);
            }

            ack.acknowledge();

        } catch (Exception e) {
            LOG.error("Error processing attendance message: ", e);
        }
    }

    /** DLT Listener **/
    @KafkaListener(topics = {"${topic.schema.attendance}.DLT"}, concurrency = "1")
    public void listenerAttendanceDLT(ConsumerRecord<String, String> record, Acknowledgment ack) {
        String message = record.value();
        if (message == null) {
            LOG.warn("Attendance.DLT Message received but was null.");
            return;
        }
        LOG.error("Attendance.DLT Message received: {}", message);
        ack.acknowledge();
    }

    /** Insert **/
    public void insertAttendance(Map<String, Object> data) {
        String sql = "INSERT INTO attendance " +
                "(employee_id, attendance_date, status, check_in_time, check_out_time, remarks, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        jdbcTemplate.update(sql,
                data.get("employee_id"),
                data.get("attendance_date") == null ? null : convertWorkDate((Integer) data.get("attendance_date")),
                data.get("status") == null ? "Present" : data.get("status").toString(),
                data.get("check_in_time") == null ? null : convertToSqlTime(data.get("check_in_time")),
                data.get("check_out_time") == null ? null : convertToSqlTime(data.get("check_out_time")),
                data.get("remarks"),
                timestampOrNow(data.get("created_at")),
                timestampOrNow(data.get("updated_at"))
        );
    }

    /** Update **/
    public void updateAttendance(Map<String, Object> data) {
        String sql = "UPDATE attendance " +
                "SET status = ?, check_in_time = ?, check_out_time = ?, remarks = ?, updated_at = NOW() " +
                "WHERE id = ?";

        jdbcTemplate.update(sql,
                data.get("status") == null ? "Present" : data.get("status").toString(),
                data.get("check_in_time") == null ? null : convertToSqlTime(data.get("check_in_time")),
                data.get("check_out_time") == null ? null : convertToSqlTime(data.get("check_out_time")),
                data.get("remarks"),
                data.get("id")
        );
    }

    /** Soft Delete **/
    public void softDelete(int id) {
        String sql = "UPDATE attendance SET updated_at = NOW(), remarks = 'Soft deleted' WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    /** Hard Delete **/
    public void hardDelete(int id) {
        String sql = "DELETE FROM attendance WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    /** Helper: Convert YYYYMMDD to Date **/
    private java.sql.Date convertWorkDate(Object value) {
        if (value == null) return null;

        if (value instanceof Integer) {
            Integer intVal = (Integer) value;
            String str = intVal.toString();

            if (str.length() == 8) {
                // Format YYYYMMDD
                LocalDate localDate = LocalDate.parse(str, DateTimeFormatter.ofPattern("yyyyMMdd"));
                return java.sql.Date.valueOf(localDate);
            } else {
                // Assume days since epoch
                LocalDate localDate = LocalDate.ofEpochDay(intVal);
                return java.sql.Date.valueOf(localDate);
            }
        } else if (value instanceof Long) {
            // If somehow long is sent as epoch days
            LocalDate localDate = LocalDate.ofEpochDay((Long) value);
            return java.sql.Date.valueOf(localDate);
        } else if (value instanceof String) {
            // If date comes as "2025-10-21"
            return java.sql.Date.valueOf((String) value);
        }

        throw new IllegalArgumentException("Unknown date format: " + value);
    }

    /** Helper: Convert timestamp or long **/
    private java.sql.Time convertToSqlTime(Object timeValue) {
        if (timeValue == null) return null;

        if (timeValue instanceof String) {
            return java.sql.Time.valueOf(timeValue.toString());
        } else if (timeValue instanceof Long) {
            return new java.sql.Time((Long) timeValue);
        }

        throw new IllegalArgumentException("Unknown time format: " + timeValue);
    }

    /** Helper: handle timestamp fields **/
    private Timestamp timestampOrNow(Object value) {
        if (value == null) return new Timestamp(System.currentTimeMillis());
        String formatted = value.toString().replace("T", " ").replace("Z", "");
        return Timestamp.valueOf(formatted);
    }
}
