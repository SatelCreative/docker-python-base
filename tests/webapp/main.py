from fastapi import FastAPI

app = FastAPI()


@app.get('/')
async def root():
    blah = 5
    """A simple Hello World endpoint"""
    return {'message': 'Hello World'}
