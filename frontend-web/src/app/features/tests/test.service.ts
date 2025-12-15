import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../../environments/environment';

export interface TestResult {
  id: number;
  templateTitle: string;
  patientName: string;
  score: number;
  submittedAt: string;
  status: 'COMPLETED' | 'PENDING';
}

export interface TestTemplate {
  id: number;
  title: string;
  description: string;
  category: string;
}

@Injectable({
  providedIn: 'root'
})
export class TestService {
  private apiUrl = `${environment.apiUrl}/tests`;

  constructor(private http: HttpClient) { }

  startTest(patientId: number, qcmId: number, phaseId: number = 1): Observable<TestResult> {
    return this.http.post<TestResult>(`${this.apiUrl}/start`, { patientId, qcmId, phaseId });
  }

  getTemplates(): Observable<TestTemplate[]> {
    return this.http.get<TestTemplate[]>(`${environment.apiUrl}/qcms`);
  }

  createTemplate(template: TestTemplate): Observable<TestTemplate> {
    return this.http.post<TestTemplate>(`${environment.apiUrl}/qcms`, template);
  }

  updateTemplate(id: number, template: TestTemplate): Observable<TestTemplate> {
    return this.http.put<TestTemplate>(`${environment.apiUrl}/qcms/${id}`, template);
  }

  deleteTemplate(id: number): Observable<void> {
    return this.http.delete<void>(`${environment.apiUrl}/qcms/${id}`);
  }

  getQuestions(templateId: number): Observable<any[]> {
    return this.http.get<any[]>(`${environment.apiUrl}/qcms/${templateId}/questions`);
  }

  createQuestion(templateId: number, question: any): Observable<any> {
    return this.http.post<any>(`${environment.apiUrl}/qcms/${templateId}/questions`, question);
  }

  updateQuestion(questionId: number, question: any): Observable<any> {
    return this.http.put<any>(`${environment.apiUrl}/qcms/questions/${questionId}`, question);
  }

  deleteQuestion(questionId: number): Observable<void> {
    return this.http.delete<void>(`${environment.apiUrl}/qcms/questions/${questionId}`);
  }

  getTestsByPatient(patientId: number): Observable<TestResult[]> {
    return this.http.get<any[]>(`${this.apiUrl}/patient/${patientId}`).pipe(
      map((tests: any[]) => tests.map((t: any) => ({
        id: t.id,
        templateTitle: t.qcmTemplate?.title || 'Unknown Test',
        patientName: t.user ? `${t.user.firstName} ${t.user.lastName}` : (t.patientId ? `Patient #${t.patientId}` : 'Unknown Patient'),
        score: t.score,
        submittedAt: t.createdAt,
        status: t.status
      })))
    );
  }

  getTests(): Observable<TestResult[]> {
    return this.http.get<any[]>(`${this.apiUrl}/doctor`).pipe(
      map((tests: any[]) => tests.map((t: any) => ({
        id: t.id,
        templateTitle: t.qcmTemplate?.title || 'Unknown Test',
        patientName: t.patient ? `${t.patient.firstName} ${t.patient.lastName}` : 'Unknown Patient',
        score: t.score,
        submittedAt: t.createdAt,
        status: t.status
      })))
    );
  }
}
