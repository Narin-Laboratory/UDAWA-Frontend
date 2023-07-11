import { Component, OnInit } from '@angular/core';
import { WebsocketService } from '../websocket.service';
import { Router } from '@angular/router';
import { Network } from '@capacitor/network';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})

export class LoginComponent implements OnInit{
  public deviceAddress = '';
  public apiKey = '';
  public message = {status: {code: 0, msg: ''}};

  constructor(
    private wsService: WebsocketService,
    private router: Router
  ) { }

  ngOnInit(): void {
    
  }

  public login(): void {
    this.wsService.initialize(this.deviceAddress, this.apiKey);
    this.wsService.connect().subscribe({
      next: (msg) => {
        if (msg && msg.status && msg.status.code != null && msg.status.code === 200 && msg.status.model && msg.status.model == 'VAYUS') {
          this.router.navigate(['/dashboard-vayus']);
        }
        else if (msg && msg.status && msg.status.code != null && msg.status.code === 200 && msg.status.model && msg.status.model == 'Gadadar') {
          this.router.navigate(['/dashboard-gadadar']);
        } else {
          // handle error
          if(msg && msg.status != null){
            this.message = msg.status;
          }
        }
      },
      error: (err) => {
        
      },
    });
  }
}
