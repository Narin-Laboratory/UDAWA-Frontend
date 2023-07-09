import { Input, Component, OnChanges, SimpleChanges, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { Chart, ChartConfiguration, ChartEvent, ChartType, TimeScale, TimeSeriesScale } from 'chart.js';
import { BaseChartDirective } from 'ng2-charts';
import { DatePipe } from '@angular/common';
import * as moment from 'moment';
import * as dateFnsAdapter from 'chartjs-adapter-date-fns';
Chart.register(dateFnsAdapter);

export interface ChartData {
  labels: Array<any>;
  series: Array<any>;
}

@Component({
  selector: 'app-chart-line',
  templateUrl: './chart-line.component.html',
  styleUrls: ['./chart-line.component.css']
})
export class ChartLineComponent implements OnInit, OnDestroy, OnChanges { 
  @Input() data: ChartConfiguration['data'];

  @ViewChild(BaseChartDirective) chart?: BaseChartDirective;

  public lineChartData: ChartConfiguration['data'] = {
    datasets: [ ]
  };

  public lineChartOptions: ChartConfiguration['options'] = {
    elements: {
      line: {
        tension: 0.5
      }
    },
    scales: {
      x: {
        type: 'time',
        time: {
          displayFormats: {
              quarter: 'H:i'
            }
        }    
      }
    },

    plugins: {
      legend: { display: true }
    }
  };
  lineChartType: ChartType = 'line';

  ngOnInit(): void {

  };

  ngOnChanges(changes: SimpleChanges): void {
    if(changes['data'] && !changes['data'].firstChange){
      this.lineChartData = this.data;
      this.update();
    }
  };
  
  ngOnDestroy(): void {
    
  };

  public update(){
    this.chart?.update();
    
  }
  
  public chartClicked({ event, active }: { event?: ChartEvent, active?: {}[] }): void {
    //console.log(event, active);
  }

  public chartHovered({ event, active }: { event?: ChartEvent, active?: {}[] }): void {
    //console.log(event, active);
  }
}
