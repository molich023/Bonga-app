# functions/liveness_check/liveness_check.py
import json
import os
import base64
from supabase import create_client, Client

supabase: Client = create_client(
    os.environ.get("SUPABASE_URL"),
    os.environ.get("SUPABASE_KEY")
)

def handler(event, context):
    try:
        body = json.loads(event["body"])
        user_id = body["user_id"]
        image_base64 = body["image"]

        # Save to Supabase Storage
        image_data = base64.b64decode(image_base64.split(",")[1])
        with open("/tmp/temp.jpg", "wb") as f:
            f.write(image_data)

        # Upload to Supabase
        with open("/tmp/temp.jpg", "rb") as img_file:
            supabase.storage.from_("kyc_images").upload(
                f"{user_id}.jpg",
                img_file,
                {"content-type": "image/jpeg"}
            )

        # Save to DB (mark as pending)
        supabase.table("kyc_submissions").insert({
            "user_id": user_id,
            "image_url": f"https://your-project-ref.supabase.co/storage/v1/object/public/kyc_images/{user_id}.jpg",
            "status": "pending"
        }).execute()

        return {
            "statusCode": 200,
            "body": json.dumps({
                "success": True,
                "message": "KYC submitted for manual review",
                "image_url": f"https://your-project-ref.supabase.co/storage/v1/object/public/kyc_images/{user_id}.jpg"
            })
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
