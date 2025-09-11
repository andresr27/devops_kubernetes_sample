#!/usr/bin/env python3
import os
import requests
from .json_logs import log

source_id = os.getenv("SOURCE_ID", "Env var not set")


def check_list():
    result = []
    for line in open("check_list.txt"):
        li = line.strip()
        if li not in ['\n', '\r\n', '']:
            if not (li.startswith("#")):
                check_parms = line.split(" ")
                result.append(check_parms)
    return result


def https_check(synth_check):
    response = None
    url = None
    timeout = 10  # seconds
    try:
        url = f"{synth_check[1]}://{synth_check[0]}:{synth_check[2]}{synth_check[3]}"
        url = url.rstrip()
        response = requests.get(url, timeout=timeout)
        response.raise_for_status()
        result = {
            "check_name": synth_check[0],
            "endpoint": url,    
            "status_code": response.status_code,
            "source_id": source_id,
            "message": "Omitted"
        }
    except requests.exceptions.ConnectTimeout:
        result = {
            "check_name": synth_check[0],
            "endpoint": url, 
            "status_code": 504,
            "source_id": source_id,
            "message": f"Request timeout of {timeout}s expired"
        }
    except requests.exceptions.HTTPError:
        result = {
            "check_name": synth_check[0],
            "endpoint": url,
            "status_code": response.status_code,
            "source_id": source_id,
            "message": response.content
        }
    except requests.exceptions.ConnectionError as e:
        result = {
            "check_name": synth_check[0],
            "endpoint": url,
            "status_code": 502,
            "source_id": source_id,
            "message": e
        }
    return result


def check(synth_check):
    try:
        if synth_check[1] == ("https" or "http"):
            return https_check(synth_check)
        else:
            raise TypeError({"endpoint": f"{synth_check[0]}", "error_message": f" {synth_check[1]} check not supported, extra spaces can cause this"})
    except IndexError as e:
        log.error({"endpoint": f"{synth_check[0]}", "error_message": f"{e}"})


def run_synth_checks():
    for endpoint in check_list():
        try:
            message = check(endpoint)
            log.info(message)
        except TypeError as e:
            log.error(e.args[0])
    return None
