import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute } from '@angular/router';
import { MatTabsModule } from '@angular/material/tabs';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatListModule } from '@angular/material/list';
import { User } from '../../../core/models/user.model';
import { PatientService } from '../../../core/services/patient.service';
import { TestService, TestResult } from '../../tests/test.service';

@Component({
  selector: 'app-patient-detail',
  standalone: true,
  imports: [
    CommonModule,
    MatTabsModule,
    MatCardModule,
    MatIconModule,
    MatButtonModule,
    MatListModule
  ],
  templateUrl: './patient-detail.component.html',
  styleUrls: ['./patient-detail.component.scss']
})
export class PatientDetailComponent implements OnInit {
  patient: User | null = null;
  tests: TestResult[] = [];

  // AI Analysis - will be populated from API
  aiAnalysis: any = {
    summary: "Loading...",
    riskLevel: "Unknown",
    recommendations: []
  };

  // Voice Chats - will be populated from API
  voiceChats: any[] = [];

  constructor(
    private route: ActivatedRoute,
    private patientService: PatientService,
    private testService: TestService
  ) { }

  ngOnInit() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.loadData(+id);
    }
  }

  loadData(id: number) {
    this.patientService.getPatientById(id).subscribe(patient => {
      this.patient = patient;
    });

    this.testService.getTestsByPatient(id).subscribe(tests => {
      this.tests = tests;
    });

    this.patientService.getPatientAnalysis(id).subscribe({
      next: (analysis) => {
        this.aiAnalysis = analysis;
      },
      error: (err) => {
        console.error('Error loading analysis:', err);
        this.aiAnalysis = {
          summary: "No voice analysis data available for this user.",
          riskLevel: "Unknown",
          recommendations: []
        };
      }
    });

    this.patientService.getPatientVoiceChats(id).subscribe({
      next: (chats) => {
        this.voiceChats = chats;
      },
      error: (err) => {
        console.error('Error loading voice chats:', err);
        this.voiceChats = [];
      }
    });
  }

  formatRisk(level: string): string {
    return level.toLowerCase(); // for css class
  }
}

