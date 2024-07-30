from flask import Flask, request, jsonify
import requests
from io import BytesIO

app = Flask(__name__)

# 設定 OpenAI Whisper API 的相關參數
with open('../secret/api.txt', 'r') as file:
    OPENAI_API_KEY = file.read().strip()

WHISPER_API_URL = 'https://api.openai.com/v1/audio/transcriptions'


def transcribe_audio(audio_file):
    headers = {
        'Authorization': f'Bearer {OPENAI_API_KEY}'
    }

    files = {
        'file': ('audio.m4a', audio_file, 'audio/x-m4a')
    }

    data = {
        'model': 'whisper-1'
    }


    try:
        response = requests.post(WHISPER_API_URL, headers=headers, files=files, data = data)
        print(f"Whisper API Response: {response.status_code} - {response.text}")
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error calling Whisper API: {e}")
        return {'error': str(e)}


@app.route('/transcribe', methods=['POST'])
def transcribe():
    audio_file = BytesIO(request.data)
    
    # 調用轉錄函數
    transcription_result = transcribe_audio(audio_file)
    return jsonify(transcription_result)


if __name__ == '__main__':
    app.run(debug=True, port=8080)
