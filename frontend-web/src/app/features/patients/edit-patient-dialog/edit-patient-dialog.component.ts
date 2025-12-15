import { Component, Inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { PatientService } from '../../../core/services/patient.service';
import { User } from '../../../core/models/user.model';

@Component({
  selector: 'app-edit-patient-dialog',
  standalone: true,
  imports: [
    CommonModule,
    MatDialogModule,
    MatButtonModule,
    MatInputModule,
    MatFormFieldModule,
    ReactiveFormsModule
  ],
  templateUrl: './edit-patient-dialog.component.html',
  styleUrls: ['./edit-patient-dialog.component.scss']
})
export class EditPatientDialogComponent implements OnInit {
  patientForm: FormGroup;
  isSubmitting = false;

  constructor(
    private fb: FormBuilder,
    private patientService: PatientService,
    private dialogRef: MatDialogRef<EditPatientDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: { patient: User }
  ) {
    this.patientForm = this.fb.group({
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]]
    });
  }

  ngOnInit() {
    if (this.data.patient) {
      this.patientForm.patchValue({
        firstName: this.data.patient.firstName,
        lastName: this.data.patient.lastName,
        email: this.data.patient.email
      });
    }
  }

  onSubmit() {
    if (this.patientForm.valid) {
      this.isSubmitting = true;
      const updatedData = { ...this.data.patient, ...this.patientForm.value };

      this.patientService.updatePatient(this.data.patient.id!, updatedData).subscribe({
        next: (result) => {
          this.isSubmitting = false;
          this.dialogRef.close(result);
        },
        error: (err) => {
          console.error('Error updating patient', err);
          this.isSubmitting = false;
        }
      });
    }
  }

  onCancel() {
    this.dialogRef.close();
  }
}
