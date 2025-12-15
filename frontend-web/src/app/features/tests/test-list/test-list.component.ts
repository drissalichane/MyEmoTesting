import { Component, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatTableModule, MatTableDataSource } from '@angular/material/table';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatSort, MatSortModule } from '@angular/material/sort';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { TestService, TestResult } from '../test.service';
import { AssignTestDialogComponent } from '../assign-test-dialog/assign-test-dialog.component';

@Component({
  selector: 'app-test-list',
  standalone: true,
  imports: [
    CommonModule,
    MatTableModule,
    MatPaginatorModule,
    MatSortModule,
    MatIconModule,
    MatButtonModule,
    MatInputModule,
    MatFormFieldModule,
    MatDialogModule
  ],
  templateUrl: './test-list.component.html',
  styleUrls: ['./test-list.component.scss']
})
export class TestListComponent implements OnInit, AfterViewInit {
  displayedColumns: string[] = ['patient', 'test', 'score', 'date', 'status', 'actions'];
  dataSource: MatTableDataSource<TestResult>;

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  constructor(
    private testService: TestService,
    private dialog: MatDialog
  ) {
    this.dataSource = new MatTableDataSource<TestResult>([]);
  }

  ngOnInit() {
    this.loadTests();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  loadTests() {
    this.testService.getTests().subscribe({
      next: (tests) => {
        this.dataSource.data = tests;
      },
      error: (error) => console.error('Error loading tests', error)
    });
  }

  openAssignDialog() {
    const dialogRef = this.dialog.open(AssignTestDialogComponent, {
      width: '500px',
      panelClass: 'glass-dialog'
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        // Refresh list
        this.loadTests();
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

  viewResult(id: number) {
    console.log('View result', id);
  }
}
