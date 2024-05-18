import re
from fastapi.responses import JSONResponse
import requests
from fastapi import FastAPI, Form, Request, Response, File, Depends, HTTPException, status
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.encoders import jsonable_encoder
from langchain_community.llms import CTransformers
from langchain.chains import QAGenerationChain
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.docstore.document import Document
from langchain_community.document_loaders import PyPDFLoader
from langchain.prompts import PromptTemplate
from langchain_community.embeddings import HuggingFaceBgeEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.chains.summarize import load_summarize_chain
from langchain.chains import RetrievalQA
import os 
import json
import time
import uvicorn
import aiofiles
from PyPDF2 import PdfReader
import csv
from langchain_community.output_parsers.rail_parser import GuardrailsOutputParser
from model import *

app = FastAPI()





with open("CREDS.json") as f:
    content = json.load(f)
    LLMtoken=content['key']
    USERVERIFY_URL=content['USERVERIFY_URL']


def remove_numbers_from_questions(questions):
    clean_questions = []
    for question in questions:
        clean_question = re.sub(r'\d+\.', '', question)
        clean_question = clean_question.strip()
        clean_questions.append(clean_question)
    return clean_questions

def remove_first_space(text):
    if text.startswith(' '):
        return text[1:]
    else:
        return text


def generate(content):
    ques_json = {}
    
    
    answer_generation_chain, ques_list = llm_pipeline(content)
    clean_questions=remove_numbers_from_questions(ques_list)
    
    # answer_generation_chain, ques_list = mock_llm_pipeline(content) 
    for question in clean_questions: 
        
        answer = answer_generation_chain.run(question)
        
        ques_json[question] = remove_first_space(answer)
        # ques_json[question] = "answer: " + question
        

    return ques_json


@app.post('/questions') 
async def main(request: Request):
    receiving_data = await request.json()
    user = receiving_data['user']
    usertoken = receiving_data['usertoken']
    content = receiving_data['content']
    
    sending_data = {
        'user': user,
        'usertoken': usertoken,
        'llmtoken': LLMtoken
    }
    URL = USERVERIFY_URL + 'llm/validateUser'
    
    response = requests.get(URL, json=sending_data)
    
    if response.json()['access'] != True:
        return JSONResponse(content={'message': 'Access denied'}, status_code=401)
    else:
        ques_json = generate(content)
        return JSONResponse(content={
            'message': 'Questions generated successfully',
            'total_questions': len(ques_json),
            'questions': convert_json_to_listoflists(ques_json)
            }, status_code=200)

def convert_json_to_listoflists(json_data):
    data = []
    for key, value in json_data.items():
        data.append([key, value])
    return data  

@app.post('/test') 
async def test(request: Request):
    receiving_data = await request.json()
    user = receiving_data['user']
    usertoken = receiving_data['usertoken']
    content = receiving_data['content']

    
    ques_json= {
        'What is the capital of India?': 'New Delhi',
        'What is the capital of Japan?': 'Tokyo',
        'What is the capital of USA?': 'Washington DC'
    }    
    sending_data = {
        'user': user,
        'usertoken': usertoken,
        'llmtoken': LLMtoken
    }
    URL = USERVERIFY_URL + 'llm/validateUser'
    
    response = requests.get(URL, json=sending_data)
    
    if response.json()['access'] != True:
        return JSONResponse(content={'message': 'Access denied'}, status_code=401)
    else:
        time.sleep(5)
        # ques_json = generate(content)
        return JSONResponse(content={
            'message': 'Questions generated successfully',
            'total_questions': len(ques_json),
            'questions': convert_json_to_listoflists(ques_json)
            }, status_code=200)
        
if __name__ == "__main__":
    uvicorn.run("app:app", host='0.0.0.0', port=8000, reload=True)