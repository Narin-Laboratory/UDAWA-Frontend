import { Input, Component, OnChanges, SimpleChanges, OnInit, OnDestroy } from '@angular/core';
import { LineChartData } from "chartist";
import { Subscription } from 'rxjs';
import { WebsocketService } from "../websocket.service";
import { DatePipe } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { CardSwitchComponent } from '../card-switch/card-switch.component';
import { Chart, ChartConfiguration, ChartEvent, ChartType } from 'chart.js';
import { BaseChartDirective } from 'ng2-charts';


@Component({
  selector: 'app-dashboard-vayus',
  templateUrl: './dashboard-vayus.component.html',
  styleUrls: ['./dashboard-vayus.component.css']
})

export class DashboardVayusComponent implements OnInit, OnDestroy, OnChanges{
  private wsSubscription: Subscription | undefined;
  private wsDisconnectSubscription: Subscription | undefined;

  constructor(private wsService: WebsocketService, private http: HttpClient, private router: Router) {}
  
  logLoadProgress = 0;
  logLoadTS = "";
  logFileName = '';

  server = '';

  attr = {'dUsed': 0, 'dSize': 0};
  cfg = {};
  stg = {};
  deviceTelemetry = {'heap': 0};
  deviceAttributes = {};
  alarmTime = Date();
  alarmCode = 0;
  alarmMsg = {
    "0": "No alarm message.",
    "110": "The light sensor failed to initialize; please check the module integration and wiring",
    "111": "The light sensor measurement is abnormal; please check the module integrity",
    "112": "The light sensor measurement is showing an extreme value; please monitor the device's operation closely",
    "120": "The weather sensor failed to initialize; please check the module integration and wiring",
    "121": "The weather sensor measurement is abnormal; The ambient temperature is out of range",
    "122": "The weather sensor measurement is showing an extreme value; The ambient temperature is exceeding 40°C; please monitor the device's operation closely",
    "123": "The weather sensor measurement is showing an extreme value; The ambient temperature is less than 17°C; please monitor the device's operation closely",
    "124": "The weather sensor measurement is abnormal; The ambient humidity is out of range",
    "125": "The weather sensor measurement is showing an extreme value; The ambient humidity is nearly 100%; please monitor the device's operation closely",
    "126": "The weather sensor measurement is showing an extreme value; The ambient humidity is below 20%; please monitor the device's operation closely",
    "127": "The weather sensor measurement is abnormal; The barometric pressure is out of range",
    "128": "The weather sensor measurement is showing an extreme value; The barometric pressure is more than 1010hPa; please monitor the device's operation closely",
    "129": "The weather sensor measurement is showing an extreme value; The barometric pressure is less than 100hPa; please monitor the device's operation closely",
    "130": "The SD Card failed to initialize; please check the module integration and wiring",
    "131": "The SD Card failed to attatch; please check if the card is inserted properly",
    "132": "The SD Card failed to create log file; please check if the card is ok",
    "133": "The SD Card failed to write to the log file; please check if the card is ok",
    "140": "The power sensor failed to initialize; please check the module integration and wiring",
    "141": "The power sensor measurement is abnormal; The voltage reading is out of range",
    "142": "The power sensor measurement is abnormal; The current reading is out of range",
    "143": "The power sensor measurement is abnormal; The power reading is out of range",
    "144": "The power sensor measurement is abnormal; The power factor and frequency reading is out of range",
    "145": "The power sensor measurement is showing an overlimit; Please check the connected instruments",
    "150": "The device timing information is incorrect; please update the device time manually. Any function that requires precise timing will malfunction!",
    "211": "Switch number one is active, but the power sensor detects no power utilization. Please check the connected instrument to prevent failures",
    "212": "Switch number two is active, but the power sensor detects no power utilization. Please check the connected instrument to prevent failures",
    "213": "Switch number three is active, but the power sensor detects no power utilization. Please check the connected instrument to prevent failures",
    "214": "Switch number four is active, but the power sensor detects no power utilization. Please check the connected instrument to prevent failures",
    "215": "All switches are inactive, but the power sensor detects large power utilization. Please check the device relay module to prevent relay malfunction.",
    "216": "Switch numner one is active for more than one hour!",
    "217": "Switch number two is active for more than one hour!",
    "218": "Switch number three is active for more than one hour!",
    "219": "Switch number four is active for more than one hour!"
  }
  

  lightSensor = {};
  weatherSensor = {};

  public lineChartDataWeatherSensor: ChartConfiguration['data'] = {
    datasets: [ 
      {data: [], label: 'Ambient Temperature (Celcius)'},
      {data: [], label: 'Ambient Humidity (%rH)'},
      {data: [], label: 'Air Pressure (hPa)'}
     ]
  };

  public lineChartDataLightSensor: ChartConfiguration['data'] = {
    datasets: [ 
      {data: [], label: 'Illuminance (Lux)'}
     ]
  };

  ngOnInit(): void {
    const datepipe: DatePipe = new DatePipe('en-US');

    this.server = this.wsService.getServerAddress();
    this.logFileName = datepipe.transform(new Date(), 'YYYY-M-d');
    this.wsDisconnectSubscription = this.wsService.connectionClosed$.subscribe(() => { // <-- Add this line
      this.router.navigate(['/login']);
    });
    this.wsSubscription = this.wsService.connect().subscribe({
      next: (msg) => {
        // Handle received messages
        if(msg['attr'] != null){
          this.attr = msg['attr'];
        }
        if(msg['cfg'] != null){
          this.cfg = msg['cfg'];
        }
        if(msg['stg'] != null){
          this.stg = msg['stg'];
        }
        if(msg['lightSensor'] != null){
          this.lightSensor = msg['lightSensor'];
        }
        if(msg['weatherSensor'] != null){
          this.weatherSensor = msg['weatherSensor'];
        }

        if(msg['alarm'] != null){
          this.alarmCode = msg['alarm'];
        }
        if(msg['devTel'] != null){
          this.deviceTelemetry = msg['devTel'];
          let formattedDate = datepipe.transform(this.deviceTelemetry['dt'] * 1000, 'YYYY-MM-dd HH:mm:ss');
          this.deviceTelemetry['dts'] = formattedDate;
  
          this.deviceTelemetry['rssi'] = Math.min(Math.max(2 * (this.deviceTelemetry['rssi'] + 100), 0), 100);
        }
      },
      error: (err) => console.log(err),
    });
  }

  ngOnDestroy(): void {
    this.wsDisconnectSubscription?.unsubscribe();
    this.wsSubscription?.unsubscribe();
  }

  ngOnChanges(changes: SimpleChanges): void {
    
  }

  changeAttr(){
    var data = {
      'cmd': 'attr'
    };
    data["itW"] = this.stg['itW'] < 60 ? 60 : this.stg['itW'];
    data["itL"] = this.stg['itL'] < 60 ? 60 : this.stg['itL'];
    this.wsService.send(data);
    
    data = {
      'cmd': 'attr'
    };
    if(this.cfg['wssid'] != ''){data['wssid'] = this.cfg['wssid'];}
    if(this.cfg['wpass'] != ''){data['wpass'] = this.cfg['wpass'];}
    if(this.cfg['htU'] != ''){data['htU'] = this.cfg['htU'];}
    if(this.cfg['htP'] != ''){data['htP'] = this.cfg['htP'];}
    data['fIoT'] = this.cfg['fIoT'];
    data['hname'] = this.cfg['hname'];
    this.wsService.send(data);
  }

  saveSettings(){
    var data = {
      'cmd': 'saveSettings'
    };
    this.wsService.send(data);
  }

  saveConfig(){
    var data = {
      'cmd': 'configSave'
    };
    this.wsService.send(data);
  }

  panic(){
    var data = {
      'cmd': 'setPanic'
    };
    this.wsService.send(data);
  }

  reboot(){
    var data = {
      'cmd': 'reboot'
    };
    this.wsService.send(data);
  }

  wsStreamSDCard(){
    this.lineChartDataLightSensor = {
      datasets: [ 
        {data: [], label: 'Illuminance (Lux)', hidden: false},
       ]
    };
    
    this.lineChartDataWeatherSensor =  {
      datasets: [ 
        {data: [], label: 'Ambient Temperature (Celcius)', hidden: false},
        {data: [], label: 'Ambient Humidity (%rH)', hidden: true},
        {data: [], label: 'Air Pressure (hPa)', hidden: true}
       ]
    };


    this.loadJsonLineFile('http://'+this.server+'/log/'+this.logFileName+'.json').subscribe(data => {
      const lines = data.split('\n');
      
      const jsonLines = lines.map(line => {
        try {
          return JSON.parse(line);
        } catch (e) {
          //console.error('Error parsing line:', line, e);
          return {};
        }
      });
      let lineCount = jsonLines.length;
      let lineCounter = 0;

      jsonLines.forEach(msg => {
        lineCounter++;
        
        if(msg['ts'] != null){
          this.logLoadProgress = (lineCounter+1) / lineCount * 100;
          this.logLoadTS = msg['ts'];
        }
        if(msg['lux'] !=null && msg['ts'] != null)
        {
          this.lineChartDataLightSensor.datasets[0].data.push({x: msg['ts'] * 1000, y: msg['lux']});
        }
        if(msg['celc'] != null && msg['ts'] != null){
          this.lineChartDataWeatherSensor.datasets[0].data.push({x: msg['ts'] * 1000, y: msg['celc']});
          this.lineChartDataWeatherSensor.datasets[1].data.push({x: msg['ts'] * 1000, y: msg['rh']});
          this.lineChartDataWeatherSensor.datasets[2].data.push({x: msg['ts'] * 1000, y: msg['hpa']});
        }

        if(lineCounter >= lineCount){
          this.logLoadTS = "It's done! " + (lineCount - 1) + " record(s)";
        }
      });

    });
  }

  loadJsonLineFile(url: string) {
    return this.http.get(url, { responseType: 'text' });
  }
  
}
