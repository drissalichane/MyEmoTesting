import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { TestService, TestTemplate } from '../test.service';
import { PatientService } from '../../../core/services/patient.service';
import { User } from '../../../core/models/user.model';

@Component({
  selector: 'app-assign-test-dialog',
  standalone: true,
  imports: [
    CommonModule,
    MatDialogModule,
    MatButtonModule,
    MatSelectModule,
    MatFormFieldModule,
    ReactiveFormsModule
  ],
  templateUrl: './assign-test-dialog.component.html',
  styleUrls: ['./assign-test-dialog.component.scss']
})
export class AssignTestDialogComponent implements OnInit {
  assignForm: FormGroup;
  patients: User[] = [];
  templates: TestTemplate[] = [];
  isSubmitting = false;

  constructor(
    private fb: FormBuilder,
    private testService: TestService,
    private patientService: PatientService,
    private dialogRef: MatDialogRef<AssignTestDialogComponent>
  ) {
    this.assignForm = this.fb.group({
      patientId: ['', Validators.required],
      templateId: ['', Validators.required]
    });
  }

  ngOnInit() {
    this.patientService.getPatients().subscribe(p => this.patients = p);
    this.testService.getTemplates().subscribe(t => this.templates = t);
  }

  onSubmit() {
    if (this.assignForm.valid) {
      this.isSubmitting = true;
      const { patientId, templateId } = this.assignForm.value;

      this.testService.startTest(patientId, templateId).subscribe({
        next: (result) => {
          this.isSubmitting = false;
          this.dialogRef.close(result);
        },
        error: (err) => {
          console.error('Error assigning test', err);
          this.isSubmitting = false;
        }
      });
    }
  }

  onCancel() {
    this.dialogRef.close();
  }
}
