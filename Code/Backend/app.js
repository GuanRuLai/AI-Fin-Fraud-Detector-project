require('dotenv').config();
const express = require('express');
const multer = require('multer');
const fs = require('fs');
const FormData = require('form-data');
const axios = require('axios');
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;
const session = require('express-session');
const WebSocket = require('ws');
const app = express();
const port = 3000;

const upload = multer({ dest: 'uploads/' });

const users = {};

passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: 'http://localhost:3000/auth/google/callback'
  },
  function(accessToken, refreshToken, profile, done) {
    console.log('User authenticated:', JSON.stringify(profile, null, 2));
    users[profile.id] = profile;
    return done(null, profile);
  }
));

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser((id, done) => {
  done(null, users[id]);
});

app.use(express.json());
app.use(session({ secret: 'SECRET', resave: false, saveUninitialized: true }));
app.use(passport.initialize());
app.use(passport.session());

app.get('/', (req, res) => {
  res.send(`
    <html>
    <head>
      <title>AI Fin Fraud Detector</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 0;
          padding: 0;
          background-color: #f4f4f4;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }
        .container {
          text-align: center;
        }
        .btn {
          display: inline-block;
          padding: 10px 20px;
          font-size: 16px;
          color: #fff;
          background-color: #50b3a2;
          border: none;
          border-radius: 5px;
          cursor: pointer;
          text-decoration: none;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>Welcome to the AI Fin Fraud Detector!</h1>
        <a href="/auth/google" class="btn">Login with Google</a>
      </div>
    </body>
    </html>
  `);
});


app.get('/auth/google',
  passport.authenticate('google', { scope: ['profile', 'email'] })
);

app.get('/auth/google/callback', 
  passport.authenticate('google', { failureRedirect: '/' }),
  function(req, res) {
    console.log('Authentication successful. Redirecting to profile...');
    res.redirect('/profile');
  }
);

app.get('/profile', (req, res) => {
  if (!req.isAuthenticated()) {
    return res.status(401).json({ error: 'You are not authenticated' });
  }
  console.log('User accessed profile:', JSON.stringify(req.user, null, 2));
  res.send(`
    <html>
    <head>
      <title>AI Fin Fraud Detector</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          margin: 0;
          padding: 0;
          background-color: #f4f4f4;
        }
        .container {
          width: 80%;
          margin: auto;
          overflow: hidden;
        }
        header {
          background: #50b3a2;
          color: #fff;
          padding-top: 30px;
          min-height: 70px;
          border-bottom: #e8491d 3px solid;
        }
        header a {
          color: #fff;
          text-decoration: none;
          text-transform: uppercase;
          font-size: 16px;
        }
        header ul {
          padding: 0;
          list-style: none;
        }
        header li {
          display: inline;
          padding: 0 20px 0 20px;
        }
        form {
          padding: 20px;
          background: #fff;
          box-shadow: 0 0 10px #ccc;
          margin-top: 20px;
        }
        form input[type="file"] {
          display: block;
          margin-bottom: 10px;
        }
        form button {
          display: block;
          width: 100%;
          padding: 10px;
          background: #50b3a2;
          color: #fff;
          border: none;
          cursor: pointer;
        }
        #result {
          margin-top: 20px;
          padding: 20px;
          background: #fff;
          box-shadow: 0 0 10px #ccc;
        }
        pre {
          background: #f4f4f4;
          padding: 10px;
          border: 1px solid #ddd;
          overflow: auto;
        }
      </style>
    </head>
    <body>
      <header>
        <div class="container">
          <h1>Welcome ${req.user.displayName}</h1>
        </div>
      </header>
      <div class="container">
        <form id="uploadForm">
          <input type="file" name="audio" accept="audio/*" required>
          <button type="submit">Upload</button>
        </form>
        <button id="startRecord">Start Recording</button>
        <button id="stopRecord" disabled>Stop Recording</button>
        <div id="result"></div>
      </div>
      <script>
        const form = document.getElementById('uploadForm');
        const startRecordButton = document.getElementById('startRecord');
        const stopRecordButton = document.getElementById('stopRecord');
        let mediaRecorder;
        let audioChunks = [];

        form.addEventListener('submit', async (e) => {
          e.preventDefault();
          const formData = new FormData(form);
          const response = await fetch('/upload-audio', {
            method: 'POST',
            body: formData
          });
          const result = await response.json();
          document.getElementById('result').innerHTML = '<pre>' + JSON.stringify(result, null, 2) + '</pre>';
        });

        startRecordButton.addEventListener('click', async () => {
          const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
          mediaRecorder = new MediaRecorder(stream);
          mediaRecorder.start();
          startRecordButton.disabled = true;
          stopRecordButton.disabled = false;

          mediaRecorder.ondataavailable = event => {
            audioChunks.push(event.data);
          };

          mediaRecorder.onstop = async () => {
            const audioBlob = new Blob(audioChunks, { type: 'audio/wav' });
            const audioFile = new File([audioBlob], 'recorded_audio.wav', { type: 'audio/wav' });
            const formData = new FormData();
            formData.append('audio', audioFile);

            const response = await fetch('/upload-audio', {
              method: 'POST',
              body: formData
            });
            const result = await response.json();
            document.getElementById('result').innerHTML = '<pre>' + JSON.stringify(result, null, 2) + '</pre>';

            audioChunks = [];
            startRecordButton.disabled = false;
            stopRecordButton.disabled = true;
          };
        });

        stopRecordButton.addEventListener('click', () => {
          mediaRecorder.stop();
        });

        // WebSocket setup
        const socket = new WebSocket('ws://localhost:8000/ws');

        socket.onmessage = function(event) {
          const message = JSON.parse(event.data);
          const jsonViewer = new JSONViewer();
          document.getElementById('result').appendChild(jsonViewer.getContainer());
          jsonViewer.showJSON(message, null, 2);
        };

        function sendSocketMessage(message) {
          socket.send(JSON.stringify({ message: message }));
        }
      </script>
    </body>
    </html>
  `);
});

app.post('/upload-audio', upload.single('audio'), async (req, res) => {
  if (!req.isAuthenticated()) {
    console.log('Unauthenticated upload attempt');
    return res.status(401).json({ error: 'You are not authenticated' });
  }

  if (!req.file) {
    console.log('No audio file uploaded');
    return res.status(400).json({ error: 'No audio file uploaded' });
  }

  console.log('Received audio file:', req.file.originalname);

  const audioFilePath = req.file.path;

  try {
    const formData = new FormData();
    formData.append('file', fs.createReadStream(audioFilePath));

    console.log('Sending audio file to the FastAPI backend...');
    
    const response = await axios.post(`http://localhost:8000/upload`, formData, {
      headers: {
        ...formData.getHeaders(),
      },
    });

    // Clean up the uploaded file
    fs.unlinkSync(audioFilePath);

    console.log('Received response from FastAPI backend:', JSON.stringify(response.data, null, 2));

    res.json(response.data);
  } catch (error) {
    // Clean up the uploaded file
    fs.unlinkSync(audioFilePath);

    console.error('Error processing audio file:', error.message);

    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});




