import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'org.udawa.device',
  appName: 'UDAWA',
  webDir: 'dist/udawa',
  server: {
    androidScheme: 'http'
  }
};

export default config;
