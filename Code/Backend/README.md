**啟動後端伺服器**

*cd 到後端目錄(javascript)*
- cd AI-Fin-Fraud-Detector-project/Code/Backend

*開啟 app.js*
- npm install
- node app.js

*cd 到後端目錄(python)*
- cd AI-Fin-Fraud-Detector-project/Code/Backend/api

*建立 openai key*
- 到 secret 資料夾內建立 api.txt 檔，將我提供的 api key 貼入

*啟動後端*
- python3 transcribe.py

**測試後要確認檔案是否上傳請跟我聯絡**

---

**api 資訊整理**

*拿取所有錄音檔*
- http://localhost:8000/api/records (get)
    - 回傳資料（範例）：
    {
        "audio_url": "https://storage.googleapis.com/ai-fraud-detector.appspot.com/WhisperTest.m4a",
        "phone_num": "0900000000",
        "id": "0057798f-6952-48f4-8c22-33bf8bb58315",
        "record_time": "2024-07-30",
        "text_url": "https://storage.googleapis.com/ai-fraud-detector.appspot.com/WhisperTest.txt",
        "status": "Processing..."
    },

*拿取單一錄音檔*
- http://localhost:8000/api/record/:id (get)
    - 要求資料（範例）：
    網址提供錄音檔的 id

    - 回傳資料（範例）：
    {
        "audio_url": "https://storage.googleapis.com/ai-fraud-detector.appspot.com/WhisperTest.m4a",
        "phone_num": "0900000000",
        "id": "0057798f-6952-48f4-8c22-33bf8bb58315",
        "record_time": "2024-07-30",
        "text_url": "https://storage.googleapis.com/ai-fraud-detector.appspot.com/WhisperTest.txt",
        "scam_level": "Processing...",
        "alert": "Processing...",
        "score": "Processing..."
    }

*上傳錄音檔*
- http://localhost:8000/api/upload (post)
    - 要求資料（範例）：
    {
        "file": "要上傳的錄音文件（必須是二進位數據）",
        "phone_num": "上傳者的電話號碼（例如：'123456789'）",
        "record_time": "錄音的時間（例如：'2021-10-10）" （要轉換成 yyyy-mm-dd 格式）
    }
    
    - 回傳資料（範例）（暫定如此，未來串連上ai會更正）：
    {
        "audio_url": "https://storage.googleapis.com/ai-fraud-detector.appspot.com/WhisperTest.m4a",
        "text_file_url": "https://storage.googleapis.com/ai-fraud-detector.appspot.com/WhisperTest.txt",
        "record_text": "測試測試 TEST TEST"
    }

*刪除錄音檔*
- http://localhost:8000/api/delete/:id
    - 要求資料（範例）：
    網址提供錄音檔的 id


---

**資料庫架構**
```
Firestore Database
|
|-- record1 (Collection)
|   |
|   |-- (Document)
|       |-- alert（預設為空，等待與ai部分串連）
|       |-- audio_url
|       |-- id
|       |-- phone_num
|       |-- record_time
|       |-- scam_level（預設為空，等待與ai部分串連）
|       |-- score（預設為空，等待與ai部分串連）
|       |-- text_url
|
|-- users (Collection)
    |
    |-- (暫時空白，以後擴充)
```
