import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DashboardVayusComponent } from './dashboard-vayus.component';

describe('DashboardVayusComponent', () => {
  let component: DashboardVayusComponent;
  let fixture: ComponentFixture<DashboardVayusComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DashboardVayusComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DashboardVayusComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
