const { app, BrowserWindow } = require('electron')

function createWindow () {
  const win = new BrowserWindow({
    width: 1280,
    height: 800,
    webPreferences: {
      nodeIntegration: true,
    }
  })

  win.loadFile('dist/udawa/index.html')

  win.once('ready-to-show', () => {
    win.maximize();
    win.show();
  });
}

app.whenReady().then(createWindow)
