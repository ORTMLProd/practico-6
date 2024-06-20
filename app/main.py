from fastapi import FastAPI, HTTPException, Request
from fastapi import File, UploadFile
from keras.preprocessing import image
from keras.models import load_model
import numpy as np
from PIL import Image
import uvicorn
import io

print('STARTING APP')

app = FastAPI()

try:
    model = load_model('model.h5')
except Exception as e:
    print(f"Error loading model: {e}")
    model = None

@app.get("/ping")
async def health_check():
    return {"status": "OK"}

@app.post('/invocations')
async def predict(request: Request):
    file_body = await request.body()
    if not model:
        raise HTTPException(status_code=500, detail="Model could not be loaded")
    try:
        image = Image.open(io.BytesIO(file_body))
        image = image.resize((32, 32))
        image = np.expand_dims(image, axis=0)
        predictions = model.predict(image)
        predicted_class = np.argmax(predictions[0])
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interpreting prediction: {e}")

    return {"predicted_class": int(predicted_class)}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)




