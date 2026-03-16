# User Management API

A REST API for managing users built with Flask and PostgreSQL, fully containerised with Docker Compose.

## Tech Stack

- **Python / Flask** — REST API framework
- **PostgreSQL** — Database
- **SQLAlchemy** — ORM (Object Relational Mapper)
- **Flask-Migrate** — Database migrations
- **Docker + Docker Compose** — Containerisation
- **Multi-stage Dockerfile** — Optimised image build

## Project Structure

```
user-management-api/
├── app/
│   ├── __init__.py        # App factory — wires everything together
│   ├── extensions.py      # SQLAlchemy and Migrate setup
│   ├── models.py          # User database model
│   └── routes.py          # CRUD endpoints
├── migrations/            # Database migration files
├── .env                   # Secrets (never committed to GitHub)
├── .gitignore             # Ignores .env and junk files
├── docker-compose.yml     # Runs Flask + Postgres together
├── Dockerfile             # Multi-stage build for Flask app
├── Makefile               # Shortcuts for common commands
├── requirements.txt       # Python dependencies
└── prompts.txt            # AI assistance log
```

## Prerequisites

- Docker Desktop installed and running
- Make installed

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/LekhanaChandrashekar/user-management-api.git
cd user-management-api
```

### 2. Create your .env file

Create a `.env` file in the root folder with these values:

```
POSTGRES_USER=admin
POSTGRES_PASSWORD=secret123
POSTGRES_DB=usersdb
POSTGRES_HOST=db
POSTGRES_PORT=5432
DATABASE_URL=postgresql://admin:secret123@db:5432/usersdb
```

### 3. Start the application

```bash
make up
```

This builds the Docker image and starts both Flask and Postgres containers.

### 4. Run database migrations

```bash
docker compose exec app flask --app app db upgrade
```

### 5. Verify everything is running

```bash
make ps
```

You should see both containers running:
- `user-management-api-app-1` on port 5000
- `user-management-api-db-1` on port 5432

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/users` | Get all users |
| GET | `/users/<id>` | Get one user by ID |
| POST | `/users` | Create a new user |
| PUT | `/users/<id>` | Update a user |
| DELETE | `/users/<id>` | Delete a user |

## Example Requests

### Create a user (POST)
```json
POST http://localhost:5000/users
Content-Type: application/json

{
    "username": "lekhana",
    "email": "lekhana@gmail.com",
    "password": "test123"
}
```

### Response
```json
{
    "id": 1,
    "username": "lekhana",
    "email": "lekhana@gmail.com",
    "created_at": "2026-03-15T13:35:30.456423"
}
```

### Get all users (GET)
```
GET http://localhost:5000/users
```

### Update a user (PUT)
```json
PUT http://localhost:5000/users/1
Content-Type: application/json

{
    "username": "lekhana_updated"
}
```

### Delete a user (DELETE)
```
DELETE http://localhost:5000/users/1
```

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make up` | Build and start all containers |
| `make down` | Stop all containers (data preserved) |
| `make clean` | Stop containers and delete volumes |
| `make logs` | View live container logs |
| `make ps` | Check container status |
| `make build` | Build images without starting |

## Data Persistence

Data persists across container restarts using a Docker named volume (`postgres_data`). Even if you run `make down` and `make up` — all your data will still be there.

To completely reset the database:
```bash
make clean
make up
```

## Docker Architecture

- **Flask container** — runs the Python API on port 5000
- **Postgres container** — runs the database on port 5432
- **Named volume** — persists database data across restarts
- **Bind mount** — syncs local code changes to container instantly
- **Docker network** — Flask connects to Postgres using hostname `db`
- **Healthcheck** — Flask waits for Postgres to be ready before starting

## Security

- All secrets stored in `.env` file
- `.env` is never committed to GitHub (protected by `.gitignore`)
- Environment variables referenced in docker-compose.yml using `${VARIABLE}` syntax

## AI Assistance

All AI prompts used during development are logged in `prompts.txt`