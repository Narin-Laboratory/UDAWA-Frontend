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
  selector: 'app-dashboard-gadadar',
  templateUrl: './dashboard-gadadar.component.html',
  styleUrls: ['./dashboard-gadadar.component.css']
})

export class DashboardGadadarComponent implements OnInit, OnDestroy, OnChanges{
  private wsSubscription: Subscription | undefined;
  private wsDisconnectSubscription: Subscription | undefined;

  constructor(private wsService: WebsocketService, private http: HttpClient, private router: Router) {}
  
  logLoadProgress = 0;
  logLoadTS = "";
  logFileName = '';

  server = '';

  selected = 1;
  state = {'ch1': 0, 'ch2': 0, 'ch3': 0, 'ch4': 0};
  cpM = {"cpM1":0,"cpM2":0,"cpM3":0,"cpM4":0};
  cp0B = {"cp0B1":0,"cp0B2":0,"cp0B3":0,"cp0B4":0};
  cp1A = {"cp1A1":0,"cp1A2":0,"cp1A3":0,"cp1A4":0};
  cp1B = {"cp1B1":2,"cp1B2":2,"cp1B3":2,"cp1B4":2};
  cp2A = {"cp2A1":0,"cp2A2":0,"cp2A3":0,"cp2A4":0};
  cp2B = {"cp2B1":0,"cp2B2":0,"cp2B3":0,"cp2B4":0};
  cp3A = {"cp3A1": "0:0:0-0","cp3A2": "0:0:0-0","cp3A3": "0:0:0-0","cp3A4": "0:0:0-0" };
  cp4A = {"cp4A1":0,"cp4A2":0,"cp4A3":0,"cp4A4":0};
  cp4B = {"cp4B1":0,"cp4B2":0,"cp4B3":0,"cp4B4":0};
  lbl = {"lbl1": "unnamed", "lbl2": "unnamed", "lbl3": "unnamed", "lbl4": "unnamed"};

  opMode = [
    'Manual Switch',
    'Duty Cycle',
    'Datetime',
    'Time Daily',
    'Interval',
    'Environment Condition',
    'Multiple Time Daily'
  ];
  channel = [1, 2, 3, 4];

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
  
  public lineChartDataPowerSensor: ChartConfiguration['data'] = {
    datasets: [ 
      {data: [], label: 'Voltage (Volt)'},
      {data: [], label: 'Current (Amp)'},
      {data: [], label: 'Active Power (Watt)'},
      {data: [], label: 'Frequency (Hz)'},
      {data: [], label: 'Power Factor (%)'}
     ]
  };

  public lineChartDataWeatherSensor: ChartConfiguration['data'] = {
    datasets: [ 
      {data: [], label: 'Ambient Temperature (Celcius)'},
      {data: [], label: 'Ambient Humidity (%rH)'},
      {data: [], label: 'Air Pressure (hPa)'}
     ]
  };

  powerSensor = {};
  weatherSensor = {};
  
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
        if(msg['powerSensor'] != null){
          this.powerSensor = msg['powerSensor'];
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
        if(msg['cp0B'] != null){
          this.cp0B = msg['cp0B'];
        }
        if(msg['cp1A'] != null){
          this.cp1A = msg['cp1A'];
        }
        if(msg['cp1B'] != null){
          this.cp1B = msg['cp1B'];
        }
        if(msg['cp2A'] != null){
          let temp = msg['cp2A'];
          for(let i = 1; i <= 4; i++){
            const datepipe: DatePipe = new DatePipe('en-US')
            let formattedDate = datepipe.transform(temp["cp2A"+i], 'YYYY-MM-dd HH:mm:ss');
            temp["cp2A"+i] = formattedDate;
          }
          this.cp2A = temp;
        }
        if(msg['cp2B'] != null){
          this.cp2B = msg['cp2B'];
        }
        if(msg['cp4A'] != null){
          this.cp4A = msg['cp4A'];
        }
        if(msg['cp4B'] != null){
          this.cp4B = msg['cp4B'];
        }
        if(msg['cpM'] != null){
          this.cpM = msg['cpM'];
        }
        if(msg['lbl'] != null){
          this.lbl = msg['lbl'];
        }
        if(msg['cp3A'] != null){
          let temp = msg['cp3A'];
            for(let k in temp){
              let item = JSON.parse(temp[k]);
              let param: string = '';
              for(let t in item){
                let c: string = `${item[t]['h']}:${item[t]['i']}:${item[t]['s']}-${item[t]['d']}`;
                if(param == ''){
                  param += c;
                }
                else{
                  param += ",";
                  param += c;
                }
              }
              this.cp3A[k] = param;
            }
        }
        for(let i = 1; i <= 4; i++){
          if(msg['ch'+i] != null){
            this.state['ch'+i] = msg['ch'+i];
          }
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
    for(let key in this.lbl){
      data[key] = this.lbl[key];
    }
    data["itW"] = this.stg['itW'] < 900 ? 900 : this.stg['itW'];
    data["itP"] = this.stg['itP'] < 900 ? 900 : this.stg['itP'];
    this.wsService.send(data);
    
    data = {
      'cmd': 'attr'
    };
    if(this.cfg['wssid'] != ''){data['wssid'] = this.cfg['wssid'];}
    if(this.cfg['wpass'] != ''){data['wpass'] = this.cfg['wpass'];}
    if(this.cfg['apiKey'] != ''){data['apiKey'] = this.cfg['apiKey'];}
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

  saveState(){
    var data = {
      'cmd': 'saveState'
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

  changeState(){
    this.state['ch'+this.selected] = Number(this.state['ch'+this.selected]);
    var data = {
      'cmd': 'setSwitch'
    };
    data['ch'] = 'ch' + this.selected;
    data['state'] = Number(this.state['ch' + this.selected]);

    this.wsService.send(data);
  }

  changeParams(){
    var data = {
      'cmd': 'attr',
    };

    data['cpM'+this.selected] = this.cpM['cpM'+this.selected];
    
    data['cp0B'+this.selected] = this.cp0B['cp0B'+this.selected];
    data['cp1A'+this.selected] = this.cp1A['cp1A'+this.selected];
    data['cp1B'+this.selected] = this.cp1B['cp1B'+this.selected];
    let ts = new Date(this.cp2A['cp2A'+this.selected]);
    data['cp2A'+this.selected] = ts.getTime();
    data['cp2B'+this.selected] = this.cp2B['cp2B'+this.selected];

    let cp3A = [];
    let _cp3A: object = this.cp3A['cp3A'+this.selected].split(',',24);
    for(let k in _cp3A){
      let z ={'h': 0, 'i': 0, 's': 0, 'd': 0};
      let a = _cp3A[k].split('-',2);
      z['d'] = a[1];
      let b: object = a[0].split(':',3);
      z['h'] = b[0]; z['i'] = b[1]; z['s'] = b[2];
      cp3A.push(z);
    }

    data['cp3A'+this.selected] = JSON.stringify(cp3A);

    data['cp4A'+this.selected] = this.cp4A['cp4A'+this.selected];
    data['cp4B'+this.selected] = this.cp4B['cp4B'+this.selected];

    this.wsService.send(data);
  }

  wsStreamSDCard(){
    this.lineChartDataPowerSensor = {
      datasets: [ 
        {data: [], label: 'Voltage (Volt)', hidden: true},
        {data: [], label: 'Current (Amp)', hidden: true},
        {data: [], label: 'Active Power (Watt)', hidden: false},
        {data: [], label: 'Frequency (Hz)', hidden: true},
        {data: [], label: 'Power Factor (%)', hidden: true}
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
        if(msg['watt'] !=null && msg['ts'] != null)
        {
          this.lineChartDataPowerSensor.datasets[0].data.push({x: msg['ts'] * 1000, y: msg['volt']});
          this.lineChartDataPowerSensor.datasets[1].data.push({x: msg['ts'] * 1000, y: msg['amp']});
          this.lineChartDataPowerSensor.datasets[2].data.push({x: msg['ts'] * 1000, y: msg['watt']});
          this.lineChartDataPowerSensor.datasets[3].data.push({x: msg['ts'] * 1000, y: msg['freq']});
          this.lineChartDataPowerSensor.datasets[4].data.push({x: msg['ts'] * 1000, y: msg['pf']});
        }
        if(msg['celc'] != null && msg['ts'] != null){
          this.lineChartDataWeatherSensor.datasets[0].data.push({x: msg['ts'] * 1000, y: msg['celc']});
          this.lineChartDataWeatherSensor.datasets[1].data.push({x: msg['ts'] * 1000, y: msg['rh']});
          this.lineChartDataWeatherSensor.datasets[2].data.push({x: msg['ts'] * 1000, y: msg['hpa']});
        }

        if(lineCounter >= lineCount){
          this.logLoadTS = "It's done! " + lineCount + " record(s)";
        }
      });

    });
  }

  loadJsonLineFile(url: string) {
    return this.http.get(url, { responseType: 'text' });
  }
  
}
