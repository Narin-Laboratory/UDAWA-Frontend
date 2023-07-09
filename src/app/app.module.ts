import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { Routes, RouterModule } from '@angular/router';
import { WebsocketGuard } from './websocket.guard';

import { AppComponent } from './app.component';
import { FormsModule } from '@angular/forms';
import { DashboardVayusComponent } from './dashboard-vayus/dashboard-vayus.component';
import { DashboardGadadarComponent } from './dashboard-gadadar/dashboard-gadadar.component';
import { CardSensorComponent } from './card-sensor/card-sensor.component';
import { CardSwitchComponent } from './card-switch/card-switch.component';
import { WebsocketService } from './websocket.service';
import { ChartistModule } from "ng-chartist";
import { ChartLineComponent } from './chart-line/chart-line.component';
import { LoginComponent } from './login/login.component';
import { NgChartsModule } from 'ng2-charts';

const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'dashboard-vayus', component: DashboardVayusComponent, canActivate: [WebsocketGuard] },
  { path: 'dashboard-gadadar', component: DashboardGadadarComponent, canActivate: [WebsocketGuard] },
];

@NgModule({
  declarations: [
    AppComponent,
    DashboardVayusComponent,
    DashboardGadadarComponent,
    CardSensorComponent,
    CardSwitchComponent,
    ChartLineComponent,
    LoginComponent
  ],
  imports: [
    BrowserModule,
    NgChartsModule,
    FormsModule,
    ChartistModule,
    HttpClientModule,
    RouterModule.forRoot(routes)
  ],
  exports: [RouterModule],
  providers: [WebsocketService],
  bootstrap: [AppComponent]
})
export class AppRoutingModule { }