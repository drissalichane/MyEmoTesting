import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../../environments/environment';
import { User } from '../models/user.model';

@Injectable({
  providedIn: 'root'
})
export class PatientService {
  private apiUrl = `${environment.apiUrl}/users`;

  constructor(private http: HttpClient) { }

  getPatients(): Observable<User[]> {
    return this.http.get<any[]>(`${environment.apiUrl}/doctors/patients`).pipe(
      map((profiles: any[]) => profiles.map((p: any) => ({
        ...p.user,
        // Add profile data to user object if needed (e.g. currentPhase)
        currentPhase: p.currentPhase,
        birthDate: p.birthDate
      })))
    );
  }

  getPatientById(id: number): Observable<User> {
    return this.http.get<User>(`${this.apiUrl}/${id}`);
  }

  createPatient(patient: User): Observable<User> {
    // Note: Registration usually goes through AuthService, but this is for Doctor adding patient
    return this.http.post<User>(`${environment.apiUrl}/auth/register`, {
      ...patient,
      role: 'PATIENT'
    });
  }

  updatePatient(id: number, patient: Partial<User>): Observable<User> {
    return this.http.put<User>(`${this.apiUrl}/${id}`, patient);
  }

  deletePatient(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }

  getPatientAnalysis(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/${id}/analysis`);
  }

  getPatientVoiceChats(id: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/${id}/voice-chats`);
  }

  getDoctors(): Observable<User[]> {
    return this.http.get<User[]>(`${environment.apiUrl}/users/doctors`);
  }
}
