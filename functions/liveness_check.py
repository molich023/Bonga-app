# functions/liveness_check.py
import cv2
import numpy as np
from deepface import DeepFace
import base64
import os
from supabase import create_client, Client

# Initialize Supabase
supabase_url = os.environ.get("SUPABASE_URL")
supabase_key = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(supabase_url, supabase_key)

def detect_liveness(image_path):
    # Load image
    img = cv2.imread(image_path)
    if img is None:
        return {"error": "Invalid image"}

    # Convert to grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Detect faces
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    if len(faces) == 0:
        return {"error": "No face detected"}

    # Crop face
    (x, y, w, h) = faces[0]
    face_img = img[y:y+h, x:x+w]
    cv2.imwrite("cropped_face.jpg", face_img)

    # Liveness detection with DeepFace
    try:
        result = DeepFace.analyze(
            img_path="cropped_face.jpg",
            actions=['emotion', 'age', 'gender', 'race', 'liveness']
        )
        return {
            "liveness": result[0]['liveness'],
            "confidence": result[0]['liveness_confidence'],
            "is_real": result[0]['liveness_confidence'] > 0.8  # Threshold
        }
    except Exception as e:
        return {"error": str(e)}

def save_to_supabase(user_id, image_base64, liveness_result):
    # Decode base64 image
    image_data = base64.b64decode(image_base64.split(",")[1])
    with open("temp.jpg", "wb") as f:
        f.write(image_data)

    # Run liveness check
    result = detect_liveness("temp.jpg")

    # Save to Supabase
    data = supabase.table("kyc_submissions").insert({
        "user_id": user_id,
        "image_url": f"images/{user_id}.jpg",
        "liveness_result": result,
        "status": "pending"
    }).execute()

    # Upload image to Supabase Storage
    with open("temp.jpg", "rb") as img_file:
        supabase.storage.from_("kyc_images").upload(
            f"{user_id}.jpg",
            img_file,
            {"content-type": "image/jpeg"}
        )

    return data

# Netlify Function Handler
def handler(event, context):
    try:
        body = json.loads(event["body"])
        user_id = body["user_id"]
        image_base64 = body["image"]

        result = save_to_supabase(user_id, image_base64, {})
        return {
            "statusCode": 200,
            "body": json.dumps(result)
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }

# For local testing
if __name__ == "__main__":
    import json
    test_event = {
        "body": json.dumps({
            "user_id": "test_user_123",
            "image": base64.b64encode(open("test.jpg", "rb").read()).decode("utf-8")
        })
    }
    print(handler(test_event, None))
