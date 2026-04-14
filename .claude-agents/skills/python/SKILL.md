# Python Skill

Python backend development with FastAPI, Django, and best practices.

## What I Know

### FastAPI Patterns

**Application Structure**
```python
# main.py
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

app = FastAPI(title="My API")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Dependencies
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Routes
@app.get("/users/")
def read_users(db: Session = Depends(get_db)):
    users = db.query(User).all()
    return users

@app.post("/users/")
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = User(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
```

**Pydantic Models**
```python
# schemas.py
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    name: str = Field(..., min_length=2, max_length=100)

class UserCreate(UserBase):
    password: str = Field(..., min_length=8)

class UserResponse(UserBase):
    id: int
    created_at: datetime
    
    class Config:
        orm_mode = True

class UserUpdate(BaseModel):
    name: str | None = None
    email: EmailStr | None = None
```

**SQLAlchemy Models**
```python
# models.py
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    name = Column(String)
    hashed_password = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
```

### Django Patterns

**Django Project Structure**
```
myproject/
├── manage.py
├── myproject/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── apps/
    ├── users/
    │   ├── models.py
    │   ├── views.py
    │   ├── serializers.py
    │   └── urls.py
    └── posts/
```

**Django Models**
```python
# models.py
from django.db import models
from django.contrib.auth.models import User

class Post(models.Model):
    title = models.CharField(max_length=200)
    content = models.TextField()
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    published = models.BooleanField(default=False)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return self.title
```

**Django REST Framework**
```python
# serializers.py
from rest_framework import serializers
from .models import Post

class PostSerializer(serializers.ModelSerializer):
    author_name = serializers.CharField(source='author.username', read_only=True)

    class Meta:
        model = Post
        fields = ['id', 'title', 'content', 'author_name', 'created_at']

# views.py
from rest_framework import viewsets
from .models import Post
from .serializers import PostSerializer

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
```

### Python Best Practices

**1. Type Hints**
```python
from typing import List, Optional, Dict
from dataclasses import dataclass

@dataclass
class User:
    id: int
    name: str
    email: str
    metadata: Dict[str, str] | None = None

def get_users_by_role(role: str) -> List[User]:
    """Get users filtered by role."""
    return [user for user in users if user.role == role]
```

**2. Async/Await**
```python
import asyncio
import aiohttp

async def fetch_user(user_id: int) -> dict:
    async with aiohttp.ClientSession() as session:
        async with session.get(f'/users/{user_id}') as response:
            return await response.json()

async def fetch_all_users(user_ids: List[int]) -> List[dict]:
    tasks = [fetch_user(uid) for uid in user_ids]
    return await asyncio.gather(*tasks)
```

**3. Context Managers**
```python
from contextlib import contextmanager

@contextmanager
def database_transaction():
    """Handle database transactions with rollback on error."""
    try:
        yield
        db.commit()
    except Exception:
        db.rollback()
        raise
```

**4. Error Handling**
```python
class UserNotFoundError(Exception):
    """Raised when user is not found."""

def get_user(user_id: int) -> User:
    user = db.query(User).filter_by(id=user_id).first()
    if not user:
        raise UserNotFoundError(f"User {user_id} not found")
    return user

# Usage
try:
    user = get_user(user_id)
except UserNotFoundError as e:
    logger.error(str(e))
    return None
```

---

*Part of SuperAI GitHub - Centralized Claude Code Configuration*