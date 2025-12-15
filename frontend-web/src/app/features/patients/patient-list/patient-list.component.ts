import { Component, AfterViewInit, ViewChild, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { MatTableModule, MatTableDataSource } from '@angular/material/table';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatSort, MatSortModule } from '@angular/material/sort';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { User } from '../../../core/models/user.model';
import { PatientService } from '../../../core/services/patient.service';
import { AddPatientDialogComponent } from '../add-patient-dialog/add-patient-dialog.component';
import { EditPatientDialogComponent } from '../edit-patient-dialog/edit-patient-dialog.component';

@Component({
  selector: 'app-patient-list',
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatTableModule,
    MatPaginatorModule,
    MatSortModule,
    MatIconModule,
    MatButtonModule,
    MatInputModule,
    MatFormFieldModule,
    MatDialogModule
  ],
  templateUrl: './patient-list.component.html',
  styleUrls: ['./patient-list.component.scss']
})
export class PatientListComponent implements OnInit, AfterViewInit {
  displayedColumns: string[] = ['avatar', 'name', 'email', 'status', 'actions'];
  dataSource: MatTableDataSource<User>;

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  constructor(
    private router: Router,
    private patientService: PatientService,
    private dialog: MatDialog
  ) {
    this.dataSource = new MatTableDataSource<User>([]);
  }

  ngOnInit() {
    this.loadPatients();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  loadPatients() {
    this.patientService.getPatients().subscribe({
      next: (patients) => {
        this.dataSource.data = patients;
      },
      error: (error) => {
        console.error('Error loading patients', error);
      }
    });
  }

  openAddPatientDialog() {
    const dialogRef = this.dialog.open(AddPatientDialogComponent, {
      width: '500px',
      panelClass: 'glass-dialog'
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.loadPatients();
      }
    });
  }

  openEditPatientDialog(patient: User) {
    const dialogRef = this.dialog.open(EditPatientDialogComponent, {
      width: '500px',
      panelClass: 'glass-dialog',
      data: { patient }
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.loadPatients();
      }
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  viewPatient(id: number) {
    this.router.navigate(['/patients', id]);
  }
}
