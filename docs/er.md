
# University Club and Event Management System

## ER Diagram

```mermaid
erDiagram
    STUDENT ||--o{ CLUB_MEMBERSHIP : joins
    CLUB ||--o{ CLUB_MEMBERSHIP : has
    CLUB ||--o{ EVENT : organizes
    STUDENT ||--o{ EVENT_REGISTRATION : registers
    EVENT ||--o{ EVENT_REGISTRATION : receives

    STUDENT {
        int student_id PK
        string first_name
        string last_name
        string email
        string department
    }

    CLUB {
        int club_id PK
        string club_name
        string description
    }

    CLUB_MEMBERSHIP {
        int membership_id PK
        int student_id FK
        int club_id FK
        date join_date
    }

    EVENT {
        int event_id PK
        int club_id FK
        string event_name
        date event_date
        string location
    }

    EVENT_REGISTRATION {
        int registration_id PK
        int student_id FK
        int event_id FK
        date registration_date
    }
```
