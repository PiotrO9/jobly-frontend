# Database Setup Guide

## 🚀 Krok po kroku - Konfiguracja bazy danych Supabase

### 1. **Przygotowanie**
- Upewnij się, że masz utworzony projekt w Supabase
- Masz gotowy plik `.env` z kluczami API

### 2. **Utworzenie tabel - Opcja A: Supabase Dashboard**

1. **Zaloguj się do Supabase**
   - Przejdź do [supabase.com](https://supabase.com)
   - Otwórz swój projekt

2. **Otwórz SQL Editor**
   - W lewym menu kliknij **SQL Editor**
   - Kliknij **New Query**

3. **Wykonaj schema**
   - Skopiuj całą zawartość pliku `database/schema.sql`
   - Wklej do edytora SQL
   - Kliknij **Run** (lub Ctrl+Enter)

4. **Dodaj przykładowe dane (opcjonalne)**
   - Utwórz nową kwerendę SQL
   - Skopiuj zawartość pliku `database/sample_data.sql`
   - Wykonaj zapytanie

### 3. **Utworzenie tabel - Opcja B: Table Editor**

Jeśli wolisz interfejs graficzny:

1. **Przejdź do Table Editor**
2. **Utwórz tabele ręcznie** zgodnie ze schematem:

#### Kolejność tworzenia (ważne - relacje!):
1. `companies`
2. `job_categories`
3. `user_profiles`
4. `jobs`
5. `applications`
6. `saved_jobs`
7. `job_category_relations`

### 4. **Weryfikacja**

Sprawdź czy wszystko działa:

```sql
-- Sprawdź czy tabele zostały utworzone
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Sprawdź przykładowe dane
SELECT c.name, COUNT(j.id) as jobs_count
FROM companies c
LEFT JOIN jobs j ON c.id = j.company_id
GROUP BY c.id, c.name;
```

### 5. **Konfiguracja RLS (Row Level Security)**

Polityki bezpieczeństwa są już skonfigurowane w schema.sql, ale sprawdź:

1. **Przejdź do Authentication → Policies**
2. **Sprawdź czy polityki są aktywne**
3. **Przetestuj dostęp** (zaloguj się jako użytkownik)

### 6. **Testowanie z aplikacją**

Po skonfigurowaniu bazy danych, przetestuj połączenie:

```typescript
// W komponencie Vue - opcja 1: Bezpośrednie użycie bazy danych
import { useDatabase } from '@/composables/useDatabase'

const { select } = useDatabase()

// Pobierz firmy
const { data: companies } = await select('companies')
console.log(companies)

// Pobierz oferty pracy z informacjami o firmach
const { data: jobs } = await select('jobs', {
  columns: `
    id, 
    title, 
    salary_min, 
    salary_max, 
    location,
    posted_days_ago,
    employment_type,
    experience_level,
    skills,
    companies(name, logo_url)
  `,
  filters: { status: 'active' }
})
console.log(jobs)

// OPCJA 2: Użycie dedykowanego composable (ZALECANE)
import { useJobs } from '@/composables/useJobs'

const { fetchJobs, jobs, loading } = useJobs()

// Pobierz wszystkie aktywne oferty
await fetchJobs()
console.log('Oferty pracy:', jobs.value)

// Wyszukaj oferty z filtrem
const result = await fetchJobs({
  location: 'Warsaw',
  experience: 'Mid',
  types: ['Full-time']
})
console.log('Filtrowane oferty:', result.data)
```

## 📊 **Struktura bazy danych**

```
companies
├── id (UUID, Primary Key)
├── handle (VARCHAR, Unique)
├── name (VARCHAR)
├── description (TEXT)
├── num_employees (INTEGER)
├── logo_url (TEXT)
└── timestamps

jobs
├── id (UUID, Primary Key)
├── title (VARCHAR)
├── company_id (UUID, Foreign Key → companies)
├── location (VARCHAR)
├── posted_days_ago (INTEGER) -- Auto-calculated
├── employment_type (ENUM: Full-time, Part-time, Contract, Internship)
├── experience_level (ENUM: Junior, Mid, Senior, Lead)
├── salary_min (INTEGER) -- In thousands PLN
├── salary_max (INTEGER) -- In thousands PLN
├── currency (VARCHAR, Default: 'PLN')
├── description (TEXT)
├── skills (TEXT[]) -- Array of skills
├── requirements (TEXT[])
├── benefits (TEXT[])
├── equity (DECIMAL)
├── remote_allowed (BOOLEAN)
├── status (ENUM: active, closed, draft)
├── views_count (INTEGER)
├── applications_count (INTEGER)
└── timestamps

user_profiles
├── id (UUID, Primary Key → auth.users)
├── email (VARCHAR)
├── first_name, last_name (VARCHAR)
├── username (VARCHAR, Unique)
├── bio (TEXT)
├── contact fields (URLs, location)
├── skills (TEXT[])
├── experience_years (INTEGER)
├── resume_url (TEXT)
├── is_recruiter (BOOLEAN)
├── company_id (UUID, Foreign Key → companies)
└── timestamps

applications
├── id (UUID, Primary Key)
├── user_id (UUID, Foreign Key → user_profiles)
├── job_id (UUID, Foreign Key → jobs)
├── status (ENUM)
├── cover_letter (TEXT)
├── resume_url (TEXT)
└── timestamps

saved_jobs
├── id (UUID, Primary Key)
├── user_id (UUID, Foreign Key → user_profiles)
├── job_id (UUID, Foreign Key → jobs)
└── created_at

job_categories
├── id (UUID, Primary Key)
├── name (VARCHAR, Unique)
├── description (TEXT)
├── color (VARCHAR)
└── created_at

job_category_relations
├── job_id (UUID, Foreign Key → jobs)
├── category_id (UUID, Foreign Key → job_categories)
└── PRIMARY KEY (job_id, category_id)
```

## 🔒 **Polityki bezpieczeństwa (RLS)**

- **Companies**: Wszyscy mogą przeglądać, tylko rekruterzy mogą edytować swoje firmy
- **Jobs**: Wszyscy widzą aktywne oferty, rekruterzy zarządzają ofertami swojej firmy
- **User Profiles**: Wszyscy mogą przeglądać, użytkownicy edytują swoje profile
- **Applications**: Użytkownicy widzą swoje aplikacje, rekruterzy - aplikacje do swoich ofert
- **Saved Jobs**: Użytkownicy zarządzają swoimi zapisanymi ofertami

## ❗ **Troubleshooting**

### Problem: "Permission denied for relation..."
- Sprawdź czy RLS jest włączony
- Sprawdź polityki bezpieczeństwa
- Upewnij się, że użytkownik jest zalogowany

### Problem: "Foreign key constraint..."
- Twórz tabele w odpowiedniej kolejności
- Sprawdź czy referencje są poprawne

### Problem: "Function uuid_generate_v4() does not exist"
- Upewnij się, że wykonałeś: `CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`

## 🎯 **Następne kroki**

1. ✅ Skonfiguruj bazę danych
2. 🔄 Utwórz komponenty Vue do zarządzania danymi
3. 🔄 Implementuj funkcjonalności aplikacji
4. 🔄 Dodaj testy
5. 🔄 Optymalizuj wydajność 