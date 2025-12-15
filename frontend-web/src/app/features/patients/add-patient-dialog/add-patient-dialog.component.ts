import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PatientService } from '../../../core/services/patient.service';
import { User } from '../../../core/models/user.model';

@Component({
  selector: 'app-add-patient-dialog',
  standalone: true,
  imports: [
    CommonModule,
    MatDialogModule,
    MatButtonModule,
    MatInputModule,
    MatFormFieldModule,
    ReactiveFormsModule
  ],
  templateUrl: './add-patient-dialog.component.html',
  styleUrls: ['./add-patient-dialog.component.scss']
})
export class AddPatientDialogComponent {
  patientForm: FormGroup;
  isSubmitting = false;

  constructor(
    private fb: FormBuilder,
    private patientService: PatientService,
    private dialogRef: MatDialogRef<AddPatientDialogComponent>
  ) {
    this.patientForm = this.fb.group({
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      password: ['password', Validators.required] // Default password for simplicity, or generate
    });
  }

  onSubmit() {
    if (this.patientForm.valid) {
      this.isSubmitting = true;
      const patientData: User = this.patientForm.value;

      this.patientService.createPatient(patientData).subscribe({
        next: (newPatient) => {
          this.isSubmitting = false;
          this.dialogRef.close(newPatient);
        },
        error: (err) => {
          console.error('Error creating patient', err);
          this.isSubmitting = false;
          // Ideally show snackbar error
        }
      });
    }
  }

  onCancel() {
    this.dialogRef.close();
  }
}
