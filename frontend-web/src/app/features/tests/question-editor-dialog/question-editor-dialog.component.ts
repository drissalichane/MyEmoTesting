import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule, MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { FormsModule } from '@angular/forms';
import { TestService } from '../test.service';

export interface QcmQuestion {
    id?: number;
    position: number;
    questionText: string;
    questionType: string;
    options: any;
    weight: number;
    explanation?: string;
}

@Component({
    selector: 'app-question-editor-dialog',
    standalone: true,
    imports: [
        CommonModule,
        MatDialogModule,
        MatButtonModule,
        MatIconModule,
        MatFormFieldModule,
        MatInputModule,
        MatSelectModule,
        FormsModule
    ],
    templateUrl: './question-editor-dialog.component.html',
    styleUrls: ['./question-editor-dialog.component.scss']
})
export class QuestionEditorDialogComponent {
    questions: QcmQuestion[] = [];
    loading = true;
    editingQuestion: QcmQuestion | null = null;

    constructor(
        @Inject(MAT_DIALOG_DATA) public data: { templateId: number; templateTitle: string },
        private dialogRef: MatDialogRef<QuestionEditorDialogComponent>,
        private testService: TestService
    ) {
        this.loadQuestions();
    }

    loadQuestions() {
        this.loading = true;
        this.testService.getQuestions(this.data.templateId).subscribe({
            next: (questions) => {
                this.questions = questions.sort((a, b) => a.position - b.position);
                this.loading = false;
            },
            error: (err) => {
                console.error('Error loading questions', err);
                this.loading = false;
            }
        });
    }

    addNewQuestion() {
        const newPosition = this.questions.length + 1;
        this.editingQuestion = {
            position: newPosition,
            questionText: '',
            questionType: 'SINGLE_CHOICE',
            options: {
                options: [
                    { value: 'A', text: '', points: 0 },
                    { value: 'B', text: '', points: 0 },
                    { value: 'C', text: '', points: 0 },
                    { value: 'D', text: '', points: 0 }
                ]
            },
            weight: 1.0
        };
    }

    editQuestion(question: QcmQuestion) {
        this.editingQuestion = { ...question };
    }

    saveQuestion() {
        if (!this.editingQuestion) return;

        if (this.editingQuestion.id) {
            // Update existing question
            this.testService.updateQuestion(this.editingQuestion.id, this.editingQuestion).subscribe({
                next: () => {
                    this.loadQuestions();
                    this.editingQuestion = null;
                    alert('Question updated successfully!');
                },
                error: (err) => {
                    console.error('Error updating question', err);
                    alert('Failed to update question');
                }
            });
        } else {
            // Create new question
            this.testService.createQuestion(this.data.templateId, this.editingQuestion).subscribe({
                next: () => {
                    this.loadQuestions();
                    this.editingQuestion = null;
                    alert('Question created successfully!');
                },
                error: (err) => {
                    console.error('Error creating question', err);
                    alert('Failed to create question');
                }
            });
        }
    }

    cancelEdit() {
        this.editingQuestion = null;
    }

    deleteQuestion(questionId: number) {
        if (confirm('Are you sure you want to delete this question?')) {
            this.testService.deleteQuestion(questionId).subscribe({
                next: () => {
                    this.loadQuestions();
                    alert('Question deleted successfully!');
                },
                error: (err) => {
                    console.error('Error deleting question', err);
                    alert('Failed to delete question');
                }
            });
        }
    }

    getOptionsArray(options: any): any[] {
        if (!options || !options.options) return [];
        return options.options;
    }

    close() {
        this.dialogRef.close();
    }
}
