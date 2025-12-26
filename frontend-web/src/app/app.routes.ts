import { Routes } from '@angular/router';
import { AuthGuard } from './core/guards/auth.guard';
import { LayoutComponent } from './shared/components/layout/layout.component';
import { LoginComponent } from './features/auth/login/login.component';

export const routes: Routes = [
    {
        path: 'auth',
        children: [
            { path: 'login', component: LoginComponent },
            {
                path: 'register',
                loadComponent: () => import('./features/auth/register/register.component').then(m => m.RegisterComponent)
            },
            { path: '', redirectTo: 'login', pathMatch: 'full' }
        ]
    },
    {
        path: '',
        component: LayoutComponent,
        canActivate: [AuthGuard],
        children: [
            { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
            {
                path: 'dashboard',
                loadComponent: () => import('./features/dashboard/dashboard.component').then(m => m.DashboardComponent)
            },
            {
                path: 'patients',
                loadComponent: () => import('./features/patients/patient-list/patient-list.component').then(m => m.PatientListComponent)
            },
            {
                path: 'patients/:id',
                loadComponent: () => import('./features/patients/patient-detail/patient-detail.component').then(m => m.PatientDetailComponent)
            },
            {
                path: 'qcms',
                loadComponent: () => import('./features/tests/qcm-list/qcm-list.component').then(m => m.QcmListComponent)
            },
            {
                path: 'chat',
                loadComponent: () => import('./features/chat/chat.component').then(m => m.ChatComponent)
            },
            {
                path: 'tests',
                loadComponent: () => import('./features/tests/test-list/test-list.component').then(m => m.TestListComponent)
            }
        ]
    },
    { path: '**', redirectTo: '' }
];
