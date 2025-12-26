import { Component, ViewChild } from '@angular/core'; // Add ViewChild
import { CommonModule } from '@angular/common';
import { FormsModule, NgForm } from '@angular/forms'; // Add NgForm
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';

@Component({
  selector: 'app-create-qcm-dialog',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    MatSelectModule
  ],
  template: `
    <h2 mat-dialog-title>Create New QCM Template</h2>
    <mat-dialog-content>
      <form #qcmForm="ngForm">
        <mat-form-field appearance="outline" class="full-width">
          <mat-label>Title</mat-label>
          <input matInput [(ngModel)]="qcm.title" name="title" required>
        </mat-form-field>

        <mat-form-field appearance="outline" class="full-width">
          <mat-label>Description</mat-label>
          <textarea matInput [(ngModel)]="qcm.description" name="description" rows="3" required></textarea>
        </mat-form-field>

        <mat-form-field appearance="outline" class="full-width">
          <mat-label>Category</mat-label>
          <mat-select [(ngModel)]="qcm.category" name="category" required>
            <mat-option value="MOOD">Mood Assessment</mat-option>
            <mat-option value="ANXIETY">Anxiety</mat-option>
            <mat-option value="DEPRESSION">Depression</mat-option>
            <mat-option value="STRESS">Stress</mat-option>
            <mat-option value="COPING">Coping Strategies</mat-option>
            <mat-option value="OTHER">Other</mat-option>
          </mat-select>
        </mat-form-field>
      </form>
    </mat-dialog-content>
    <mat-dialog-actions align="end">
      <button mat-button (click)="onCancel()">Cancel</button>
      <button mat-flat-button color="primary" (click)="onCreate()">
        Create
      </button>
    </mat-dialog-actions>
  `,
  styles: [`
    .full-width {
      width: 100%;
      margin-bottom: 1rem;
    }

    mat-dialog-content {
      min-width: 400px;
      padding: 1.5rem 0;
    }
  `]
})
export class CreateQcmDialogComponent {
  @ViewChild('qcmForm') qcmForm!: NgForm;

  qcm = {
    title: '',
    description: '',
    category: 'MOOD'
  };

  constructor(
    private dialogRef: MatDialogRef<CreateQcmDialogComponent>
  ) { }

  onCreate() {
    if (this.qcmForm && this.qcmForm.valid) {
      this.dialogRef.close(this.qcm);
    } else {
      this.qcmForm.form.markAllAsTouched();
    }
  }

  onCancel() {
    this.dialogRef.close();
  }
}
