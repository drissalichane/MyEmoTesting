package com.myemohealth.dto;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class PatientAnalysisDTO {
    private String summary;
    private String riskLevel;
    private List<String> recommendations;
}
