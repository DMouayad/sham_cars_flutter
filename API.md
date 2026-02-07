# Mobile API Contract

## Overview

Base URL: `/api/v1`
Authentication: Sanctum Bearer Token (Optional for Public Data)
Headers:

- `Accept: application/json`
- `Accept-Language: {en|ar}`

## 1. Reference Data



### List Body Types

- **Endpoint**: `GET /car-data/body-types`

- **Response**:

    ```json

    {

        "data": [

            {

                "id": 1,

                "name": "Sedan",

                "icon": "🚗"

            }

        ]

    }

    ```



### List Car Makes (Brands)

- **Endpoint**: `GET /car-data/makes`

- **Response**:

    ```json

    {

        "data": [

            {

                "id": 1,

                "name": "Tesla",

                "logo_url": "...",

                "country": "USA",

                "website": "..."

            }

        ]

    }

    ```



## 2. Authentication



### User Registration

- **Endpoint**: `POST /register`

- **Body**:

    ```json

    {

        "name": "string",

        "email": "string",

        "phone": "string",

        "password": "string",

        "c_password": "string"

    }

    ```

- **Response**: (On success, an empty response or a user object)



### User Login

- **Endpoint**: `POST /login`

- **Body**:

    ```json

    {

        "email": "string",

        "password": "string"

    }

    ```

- **Response**:

    ```json

    {

        "token": "string",

        "name": "string"

    }

    ```



### User Logout

- **Endpoint**: `POST /logout` (Auth Required)

- **Response**: (Success message or empty response)



### Request Verification Code

- **Endpoint**: `POST /request_otp`

- **Body**:

    ```json

    {

        "email": "string"

    }

    ```

- **Response**: (Success message or empty response)



### Verify Account

- **Endpoint**: `POST /verify_otp`

- **Body**:

    ```json

    {

        "email": "string",

        "email_otp": "string"

    }

    ```

- **Response**:

    ```json

    {

        "token": "string"

    }

    ```



### Forgot Password

- **Endpoint**: `POST /forget-password`

- **Body**:

    ```json

    {

        "email": "string"

    }

    ```

- **Response**: (Success message or empty response, indicating email sent)



### Reset Password

- **Endpoint**: `POST /user/change_password`

- **Body**:

    ```json

    {

        "token": "string",

        "password": "string",

        "password_confirmation": "string"

    }

    ```

- **Response**: (Success message or empty response)



## 3. Car Hierarchy & Details

### List Car Models (Filtered)

- **Endpoint**: `GET /car-data/models`
- **Query Params**:
    - `make_id` (optional): Filter by Brand
    - `body_type_id` (optional): Filter by Body Type
- **Response**:
    ```json
    {
        "data": [
            {
                "id": 101,
                "name": "Model 3",
                "make_name": "Tesla",
                "make_id": 1,
                "body_type_id": 1
            }
        ]
    }
    ```

### Get Car Detail (Trim Level with Specs)

- **Endpoint**: `GET /car-data/trims/{id}`
- **Response**:
    ```json
    {
        "data": {
            "id": 501,
            "name": "Long Range",
            "model_name": "Model 3",
            "make_name": "Tesla",
            "body_type": "Sedan",
            "year_start": 2024,
            "year_end": 2026,
            "price_min": 47000,
            "price_max": 52000,
            "currency": "USD",
            "description": "Long range version...",
            "is_featured": true,
            "range": {
                "value": "629",
                "unit": "km",
                "display": "629 km"
            },
            "battery_capacity": {
                "value": "75",
                "unit": "kWh",
                "display": "75 kWh"
            },
            "acceleration": {
                "value": "4.4",
                "unit": "s",
                "display": "4.4 s"
            },
            "images": ["http://.../image1.jpg", "http://.../image2.jpg"],
            "specs": {
                "Real-world Range": "629 km",
                "Battery Capacity": "75 kWh",
                "Acceleration 0-100km/h": "4.4 s",
                "Top Speed": "233 km/h",
                "Drive Type": "AWD"
            }
        }
    }
    ```

### List Car Trims (Filtered)

- **Endpoint**: `GET /car-data/trims`
- **Query Params**:
    - `search` (optional): Free-text search across trim and model names
    - `make_id` (optional): Filter by Brand
    - `model_id` (optional): Filter by Model
    - `series_id` (optional): Filter by Series
    - `body_type_id` (optional): Filter by Body Type
    - `min_price` (optional): Minimum price (matches price_min >= value)
    - `max_price` (optional): Maximum price (matches price_max <= value)
    - `min_range_km` (optional): Minimum real-world range in km (via specs)
    - `seats` (optional): Minimum seats (via specs: "Seats" or "Seating Capacity")
    - `featured` (optional): true|false
    - `published` (optional): true|false
    - `take` (optional): Page size
    - `skip` (optional): Offset
- **Response**:
    ```json
    {
        "data": [
            {
                "id": 501,
                "name": "Long Range",
                "model_name": "Model 3",
                "make_name": "Tesla",
                "body_type": "Sedan",
                "year_start": 2024,
                "year_end": 2026,
                "price_min": 47000,
                "price_max": 52000,
                "currency": "USD",
                "is_featured": true,
                "image_url": "http://.../image1.jpg",
                "range": {
                    "value": "629",
                    "unit": "km",
                    "display": "629 km"
                },
                "battery_capacity": {
                    "value": "75",
                    "unit": "kWh",
                    "display": "75 kWh"
                },
                "acceleration": {
                    "value": "4.4",
                    "unit": "s",
                    "display": "4.4 s"
                }
            }
        ]
    }
    ```

## 4. Recommendations

### Get Similar Trims (Recommendation)

- **Endpoint**: `GET /car-data/trims/{id}/similar`
- **Query Params**:
    - `take` (optional): Page size (default 5)
    - `skip` (optional): Offset (default 0)
- **Response**: List of Trim objects (Same structure as List Car Trims)

### Get Also Liked Trims (Collaborative)

- **Endpoint**: `GET /car-data/trims/{id}/also-liked`
- **Query Params**:
    - `take` (optional): Page size (default 5)
    - `skip` (optional): Offset (default 0)
- **Response**: List of Trim objects (Same structure as List Car Trims)

### Get Trending Cars (Popularity)

- **Endpoint**: `GET /car-data/trending-cars`
- **Query Params**:
    - `take` (optional): Page size (default 10)
    - `skip` (optional): Offset (default 0)
- **Response**: List of Trim objects (Same structure as List Car Trims)

### Get Hot Topics (Most Asked About)

- **Endpoint**: `GET /car-data/hot-topics`
- **Query Params**:
    - `take` (optional): Page size (default 10)
    - `skip` (optional): Offset (default 0)
- **Response**:
    ```json
    {
        "data": [
            {
                "id": 101,
                "name": "Model 3",
                "make_name": "Tesla",
                "questions_count": 50,
                "answers_count": 120,
                "is_hot": true
            }
        ]
    }
    ```

## 5. Community Features (Reviews & Q&A)

### Get Car Reviews

- **Endpoint**: `GET /community/reviews`
- **Query Params**:
    - `car_trim_id` (optional): Filter by Trim
    - `take` (optional): Page size (default 15)
    - `skip` (optional): Offset (default 0)
- **Response**:
    ```json
    {
        "data": [
            {
                "id": 1,
                "user_name": "John Doe",
                "rating": 5,
                "comment": "Amazing car!",
                "created_at": "2024-02-01 10:00:00",
                "car_trim_id": 501,
                "car_trim_name": "Long Range",
                "car_model_name": "Model 3"
            }
        ]
    }
    ```

### Post Car Review

- **Endpoint**: `POST /community/reviews` (Auth Required)
- **Body**:
    ```json
    {
        "car_trim_id": 501,
        "rating": 5,
        "comment": "..."
    }
    ```

### Get Questions (Q&A)

- **Endpoint**: `GET /community/questions`
- **Query Params**:
    - `car_model_id` (optional): Filter by Model
    - `car_trim_id` (optional): Filter by Trim
    - `take` (optional): Page size (default 15)
    - `skip` (optional): Offset (default 0)
- **Response**:
    ```json
    {
        "data": [
            {
                "id": 10,
                "car_model_id": 101,
                "car_trim_id": 501,
                "model_name": "Model 3",
                "trim_name": "Long Range",
                "user_name": "Jane Doe",
                "title": "Battery life?",
                "body": "How long does it last in winter?",
                "answers_count": 2,
                "created_at": "2024-02-01 11:00:00"
            }
        ]
    }
    ```

### Get Question Details (with Answers)

- **Endpoint**: `GET /community/questions/{id}`
- **Response**:
    ```json
    {
        "data": {
            "id": 10,
            "car_model_id": 101,
            "car_trim_id": 501,
            "model_name": "Model 3",
            "trim_name": "Long Range",
            "user_name": "Jane Doe",
            "title": "Battery life?",
            "body": "...",
            "answers": [
                {
                    "id": 20,
                    "user_name": "Admin",
                    "body": "In winter, it usually...",
                    "created_at": "2024-02-01 11:30:00"
                }
            ]
        }
    }
    ```

### Post Question

- **Endpoint**: `POST /community/questions` (Auth Required)
- **Body**:
    ```json
    {
        "car_model_id": 101,
        "car_trim_id": 501,
        "title": "...",
        "body": "..."
    }
    ```

### Post Answer

- **Endpoint**: `POST /community/questions/{id}/answers` (Auth Required)
- **Body**:
    ```json
    {
        "body": "..."
    }
    ```

## 6. User Profile

### Get User Reviews (My Reviews)

- **Endpoint**: `GET /user/reviews` (Auth Required)
- **Query Params**:
    - `limit` (optional): Page size (default 10)
    - `skip` (optional): Offset (default 0)
- **Response**:
    ```json
    {
        "data": [
            {
                "id": 10,
                "rating": 5,
                "comment": "Nice car",
                "status": "approved",
                "created_at": "...",
                "user_name": "John Doe",
                "car_trim_id": 501,
                "car_trim_name": "Long Range",
                "car_model_name": "Model 3",
                "make_name": "Tesla"
            }
        ]
    }
    ```

### Get User Questions (My Questions)

- **Endpoint**: `GET /user/questions` (Auth Required)
- **Query Params**:
    - `limit` (optional): Page size (default 10)
    - `skip` (optional): Offset (default 0)
- **Response**:
    ```json
    {
        "data": [
            {
                "id": 101,
                "title": "Battery Life?",
                "body": "How long...",
                "created_at": "...",
                "answers_count": 5,
                "user_name": "John Doe",
                "car_model_id": 202,
                "car_trim_id": 501,
                "model_name": "Model 3",
                "make_name": "Tesla",
                "trim_name": "Long Range"
            }
        ]
    }
    ```

### Get User Answered Questions

- **Endpoint**: `GET /user/answered-questions` (Auth Required)
- **Query Params**:
    - `limit` (optional): Page size (default 10)
    - `skip` (optional): Offset (default 0)
- **Response**: List of questions (same structure as above) that have `answers_count > 0`.
