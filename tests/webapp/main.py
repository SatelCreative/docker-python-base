from fastapi import FastAPI

app = FastAPI()


@app.get('/')
async def root():
    """A simple Hello World endpoint"""
    return {'message': 'Hello World'}
