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

## 2. Car Hierarchy & Details

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

## 3. Community Features (Reviews & Q&A)

### Get Car Reviews

- **Endpoint**: `GET /community/reviews`
- **Query Params**:
    - `car_trim_id` (required): Filter by Trim
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
                "created_at": "2024-02-01 10:00:00"
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
        "car_model_id": 101, // (optional)
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
