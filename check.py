import os
import re
import json
import pandas as pd
import speech_recognition as sr
import subprocess
from pydub import AudioSegment
from nltk.corpus import stopwords
from nltk import pos_tag, word_tokenize, ne_chunk
from nltk.stem import WordNetLemmatizer
import nltk
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse
from pyngrok import ngrok
import logging
import nest_asyncio

# Apply nest_asyncio to allow running nested event loops
nest_asyncio.apply()

# Download necessary NLTK data
nltk.download("stopwords")
nltk.download("averaged_perceptron_tagger")
nltk.download("punkt")
nltk.download("wordnet")
nltk.download("maxent_ne_chunker")
nltk.download("words")

# Set up lemmatizer
lemmatizer = WordNetLemmatizer()

# Specify the path to the ffmpeg executable
ffmpeg_path = r"C:\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe"
AudioSegment.converter = ffmpeg_path

# Initialize FastAPI app
app = FastAPI()

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load amplified_result.csv once when the server starts
try:
    amplified_df = pd.read_csv('amplified_result.csv')
    logger.info("Loaded amplified_result.csv successfully.")
except Exception as e:
    amplified_df = pd.DataFrame()
    logger.error(f"Error loading amplified_result.csv: {e}")

# Function to process text and extract relevant nouns and named entities
def preprocess_and_extract_nouns_and_entities(text):
    try:
        logger.info("Preprocessing text and extracting nouns and entities...")
        all_stopwords = set(stopwords.words("english"))
        text = re.sub("[^a-zA-Z]", " ", text)
        text = text.lower()
        text = word_tokenize(text)
        text = [lemmatizer.lemmatize(word) for word in text if word not in all_stopwords]
        tagged_text = pos_tag(text)
        nouns = [word for word, pos in tagged_text if pos.startswith("NN")]
        entities = ne_chunk(tagged_text)
        named_entities = []

        for chunk in entities:
            if hasattr(chunk, 'label'):
                named_entity = " ".join(c[0] for c in chunk)
                named_entities.append(named_entity)

        # Remove duplicates
        nouns = list(set(nouns))
        named_entities = list(set(named_entities))

        logger.info(f"Nouns extracted: {nouns}")
        logger.info(f"Named entities extracted: {named_entities}")
        return nouns, named_entities
    except Exception as e:
        logger.error(f"Error in preprocessing and extracting nouns and entities: {e}")
        return [], []

# Function to classify nouns into categories using amplified_result.csv
def classify_nouns_with_amplified(nouns):
    logger.info("Classifying nouns into categories...")
    categories = {
        "Money related": [],
        "Personal information related": [],
        "Inducement words related": [],
        "Promotional content related": [],
        "Kinship related": []
    }

    inducement_words = ["security", "problem", "support", "police", "virus", "accident", "irs", "message", "help", "arrest", "government", "device", "records", "access"]
    promotional_words = ["service", "internet", "system", "telemarketer", "course", "offer", "site", "sales", "gift", "order", "program", "activity", "software", "subscription", "customer"]

    for noun in nouns:
        for index, row in amplified_df.iterrows():
            for category in categories.keys():
                if noun == row[category]:
                    categories[category].append(noun)

        if noun in inducement_words:
            categories["Inducement words related"].append(noun)
        if noun in promotional_words:
            categories["Promotional content related"].append(noun)

    # Remove duplicates
    for category in categories:
        categories[category] = list(set(categories[category]))

    logger.info(f"Categories classified: {categories}")
    return categories

def calculate_risk_score(categories, weights):
    logger.info("Calculating risk score...")
    score = 0
    reasons = []

    if categories["Money related"]:
        score += weights["money"]
        reasons.append(f"High-risk money term: {', '.join(categories['Money related'])}")

    if categories["Personal information related"]:
        score += weights["personal_info"]
        reasons.append(f"Sensitive personal info requested: {', '.join(categories['Personal information related'])}")

    if categories["Inducement words related"]:
        score += weights["inducement"]
        reasons.append(f"High-risk inducement: {', '.join(categories['Inducement words related'])}")

    if categories["Promotional content related"]:
        score += weights["promotional"]
        reasons.append(f"Suspicious promotional content: {', '.join(categories['Promotional content related'])}")

    if 'warrant' in categories["Money related"] or 'taxes' in categories["Money related"]:
        if 'irs' in categories["Inducement words related"]:
            score += weights["irs_scam"]
            reasons.append("Classic IRS scam pattern")

    if 'help' in categories["Inducement words related"] or 'support' in categories["Inducement words related"]:
        if not any(kinship in categories["Kinship related"] for kinship in ["son", "husband", "wife", "mother", "dad", "children", "parents"]):
            score += weights["kinship"]
            reasons.append("Urgency combined with uncommon family relation")

    risk_evaluation = {"Risk Score": score, "Reasons": reasons}
    logger.info(f"Risk evaluation: {risk_evaluation}")
    return risk_evaluation

# Function to transcribe audio file to text
def transcribe_audio(file_path):
    recognizer = sr.Recognizer()
    logger.info(f"Transcribing audio file: {file_path}")

    # Convert audio to wav format using ffmpeg
    try:
        subprocess.run([ffmpeg_path, '-i', file_path, 'temp.wav'], check=True)
    except subprocess.CalledProcessError as e:
        logger.error(f"FFmpeg error: {e}")
        raise e

    with sr.AudioFile("temp.wav") as source:
        audio_data = recognizer.record(source)
        text = recognizer.recognize_google(audio_data)
    os.remove("temp.wav")
    logger.info(f"Transcribed text: {text}")
    return text

# Endpoint to handle file uploads and process audio files
@app.post('/upload')
async def upload_file(file: UploadFile = File(...)):
    if not file:
        raise HTTPException(status_code=400, detail="No file uploaded")
    file_path = 'uploaded_audio.wav'
    with open(file_path, "wb") as f:
        f.write(await file.read())
    logger.info(f"File saved: {file_path}")

    result = detect_fraud_from_audio(file_path)
    logger.info(f"Result: {result}")
    return JSONResponse(content=result)

# Add a root route for testing
@app.get('/')
async def read_root():
    return {"message": "FastAPI server is running!"}

def detect_fraud_from_audio(file_path):
    try:
        # Step 1: Transcribe audio to text
        transcribed_text = transcribe_audio(file_path)

        # Step 2: Extract nouns and named entities from text
        nouns, named_entities = preprocess_and_extract_nouns_and_entities(transcribed_text)

        # Step 3: Categorize extracted nouns using amplified_result.csv
        categories = classify_nouns_with_amplified(nouns)

        # Step 4: Evaluate risk score using the algorithm
        weights = {
            'money': 4,
            'personal_info': 2,
            'inducement': 3,
            'promotional': 1,
            'irs_scam': 5,
            'kinship': 2
        }

        risk_evaluation = calculate_risk_score(categories, weights)
        result = {
            "transcribed_text": transcribed_text,
            "named_entities": named_entities,
            "categories": categories,
            "risk_evaluation": risk_evaluation
        }
        return result
    except Exception as e:
        logger.error(f"Error in detecting fraud from audio: {e}")
        return {"Error": str(e)}

def start_ngrok():
    # Set your ngrok authentication token
    ngrok.set_auth_token("2k5pLbploSKq68vtbIQMOVhuSHo_3gxtZiHBe7N98BcfkxnJ4")  # Replace with your actual ngrok auth token

    # Start ngrok tunnel without a reserved subdomain
    public_url = ngrok.connect(8000)
    logger.info(" * ngrok tunnel \"{}\" -> \"http://127.0.0.1:8000\"".format(public_url))
    print(" * ngrok tunnel \"{}\" -> \"http://127.0.0.1:8000\"".format(public_url))
    return public_url

if __name__ == '__main__':
    # Start ngrok tunnel in a separate thread
    url = start_ngrok()
    
    # Print the public URL
    print(f"Public URL: {url}")

    # Run the FastAPI app with Uvicorn
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

