import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { TestService, TestTemplate } from '../test.service';
import { QuestionEditorDialogComponent } from '../question-editor-dialog/question-editor-dialog.component';
import { CreateQcmDialogComponent } from '../create-qcm-dialog/create-qcm-dialog.component';

@Component({
  selector: 'app-qcm-list',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule,
    MatDialogModule
  ],
  templateUrl: './qcm-list.component.html',
  styleUrls: ['./qcm-list.component.scss']
})
export class QcmListComponent implements OnInit {
  templates: TestTemplate[] = [];

  constructor(
    private testService: TestService,
    private dialog: MatDialog
  ) { }

  ngOnInit() {
    this.loadTemplates();
  }

  loadTemplates() {
    this.testService.getTemplates().subscribe({
      next: (data) => this.templates = data,
      error: (err) => console.error('Error loading templates', err)
    });
  }

  createTemplate() {
    const dialogRef = this.dialog.open(CreateQcmDialogComponent, {
      width: '500px'
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.testService.createTemplate(result).subscribe({
          next: (created) => {
            this.loadTemplates();
            // Open question editor for the newly created template
            this.viewQuestions(created);
          },
          error: (err) => {
            console.error('Error creating template', err);
            alert('Failed to create template');
          }
        });
      }
    });
  }

  viewQuestions(template: TestTemplate) {
    this.dialog.open(QuestionEditorDialogComponent, {
      width: '800px',
      maxHeight: '90vh',
      data: {
        templateId: template.id,
        templateTitle: template.title
      }
    });
  }

  editTemplate(template: TestTemplate) {
    const title = prompt('Edit Template Title:', template.title);
    const description = prompt('Edit Description:', template.description);

    if (title && description) {
      const updated = { ...template, title, description };
      this.testService.updateTemplate(template.id, updated).subscribe({
        next: () => {
          this.loadTemplates();
          alert('Template updated successfully!');
        },
        error: (err) => {
          console.error('Error updating template', err);
          alert('Failed to update template');
        }
      });
    }
  }

  deleteTemplate(id: number, title: string) {
    if (confirm(`Are you sure you want to delete "${title}"? This action cannot be undone.`)) {
      this.testService.deleteTemplate(id).subscribe({
        next: () => {
          this.loadTemplates();
          alert('Template deleted successfully!');
        },
        error: (err) => {
          console.error('Error deleting template', err);
          alert('Failed to delete template');
        }
      });
    }
  }
}
