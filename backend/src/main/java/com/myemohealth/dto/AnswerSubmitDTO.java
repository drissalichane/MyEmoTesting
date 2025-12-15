package com.myemohealth.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Map;

/**
 * DTO for submitting test answers
 */
@Data
public class AnswerSubmitDTO {

    private Long questionId;

    private Map<String, Object> selectedOptions;

    private BigDecimal valueNumeric;

    private String textResponse;
}
