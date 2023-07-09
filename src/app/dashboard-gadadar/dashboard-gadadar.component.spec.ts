import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DashboardGadadarComponent } from './dashboard-gadadar.component';

describe('DashboardGadadarComponent', () => {
  let component: DashboardGadadarComponent;
  let fixture: ComponentFixture<DashboardGadadarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DashboardGadadarComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(DashboardGadadarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
