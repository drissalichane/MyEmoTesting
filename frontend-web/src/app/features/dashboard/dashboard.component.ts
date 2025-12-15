import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { BaseChartDirective } from 'ng2-charts';
import { ChartConfiguration, ChartOptions } from 'chart.js';
import { AuthService } from '../../core/services/auth.service';
import { DashboardService, DashboardStats } from './dashboard.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, MatIconModule, MatButtonModule, BaseChartDirective],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  stats: DashboardStats = {
    totalPatients: 0,
    totalTests: 0,
    criticalCases: 0,
    completedTests: 0
  };

  constructor(
    public authService: AuthService,
    private dashboardService: DashboardService
  ) { }

  ngOnInit() {
    this.dashboardService.getStats().subscribe({
      next: (stats) => this.stats = stats,
      error: (err) => console.error('Error loading dashboard stats:', err)
    });
  }

  // Line Chart Configuration
  public lineChartData: ChartConfiguration<'line'>['data'] = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
    datasets: [
      {
        data: [65, 59, 80, 81, 56, 55, 40],
        label: 'Average Mood Score',
        fill: true,
        tension: 0.5,
        borderColor: '#00B7B5',
        backgroundColor: 'rgba(0, 183, 181, 0.1)',
        pointBackgroundColor: '#fff',
        pointBorderColor: '#00B7B5',
        pointHoverBackgroundColor: '#00B7B5',
        pointHoverBorderColor: '#fff'
      }
    ]
  };

  public lineChartOptions: ChartOptions<'line'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false }
    },
    scales: {
      y: {
        beginAtZero: true,
        grid: { color: 'rgba(0,0,0,0.05)' }
      },
      x: {
        grid: { display: false }
      }
    }
  };

  // Doughnut Chart Configuration
  public doughnutChartData: ChartConfiguration<'doughnut'>['data'] = {
    labels: ['Completed', 'Pending', 'Missed'],
    datasets: [
      {
        data: [350, 45, 10],
        backgroundColor: ['#018790', '#00B7B5', '#FF5252'],
        hoverBackgroundColor: ['#005461', '#008E8C', '#FF1744'],
        borderWidth: 0
      }
    ]
  };

  public doughnutChartOptions: ChartOptions<'doughnut'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { position: 'bottom' }
    },
    cutout: '70%'
  };
}
