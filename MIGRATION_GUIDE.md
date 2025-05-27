# Migration Guide - JobsView.vue ↔ Supabase Database

## 🔄 **Mapowanie pól między komponentem a bazą danych**

### **Job Interface Mapping**

| Component Field (`job.ts`) | Database Field (`jobs` table) | Type | Notes |
|---------------------------|-------------------------------|------|-------|
| `id` | `id` | `string` (UUID) | Changed from `number` to `string` |
| `title` | `title` | `string` | ✓ Identical |
| `company` | `companies.name` | `string` | Join relationship |
| `location` | `location` | `string` | ✓ Identical |
| `postedDays` | `posted_days_ago` | `number` | Auto-calculated trigger |
| `type` | `employment_type` | `string` | ✓ Same values |
| `experience` | `experience_level` | `string` | ✓ Same values |
| `salaryMin` | `salary_min` | `number` | ✓ Identical |
| `salaryMax` | `salary_max` | `number` | ✓ Identical |
| `description` | `description` | `string` | ✓ Identical |
| `skills` | `skills` | `string[]` | ✓ Identical |

### **Nowe pola w bazie danych (rozszerzenia)**

| Database Field | Type | Purpose |
|----------------|------|---------|
| `company_id` | `UUID` | Foreign key to companies table |
| `currency` | `string` | Salary currency (default: 'PLN') |
| `requirements` | `string[]` | Job requirements |
| `benefits` | `string[]` | Job benefits |
| `equity` | `decimal` | Equity percentage |
| `remote_allowed` | `boolean` | Remote work availability |
| `status` | `enum` | Job status (active/closed/draft) |
| `views_count` | `integer` | Number of job views |
| `applications_count` | `integer` | Number of applications |

## 📊 **Przykłady transformacji danych**

### **Component → Database (Insert)**
```typescript
// Dane z komponentu JobsView.vue
const jobData = {
  id: 1, // zostanie zastąpione UUID z bazy
  title: 'Frontend Developer',
  company: 'Acme Corp', // trzeba znaleźć company_id
  location: 'New York',
  postedDays: 2, // zostanie auto-obliczone
  type: 'Full-time',
  experience: 'Mid',
  salaryMin: 100,
  salaryMax: 140,
  description: 'Join our front-end team...',
  skills: ['Vue', 'JavaScript', 'TypeScript']
}

// Transformacja do formatu bazy danych
const dbJob = {
  title: jobData.title,
  company_id: await getCompanyIdByName(jobData.company),
  location: jobData.location,
  employment_type: jobData.type,
  experience_level: jobData.experience,
  salary_min: jobData.salaryMin,
  salary_max: jobData.salaryMax,
  description: jobData.description,
  skills: jobData.skills,
  // posted_days_ago będzie auto-obliczone przez trigger
  status: 'active'
}
```

### **Database → Component (Fetch)**
```typescript
// Dane z bazy danych Supabase
const dbJob = {
  id: 'uuid-string',
  title: 'Frontend Developer',
  company_id: 'company-uuid',
  location: 'New York',
  posted_days_ago: 2,
  employment_type: 'Full-time',
  experience_level: 'Mid',
  salary_min: 100,
  salary_max: 140,
  description: 'Join our front-end team...',
  skills: ['Vue', 'JavaScript', 'TypeScript'],
  companies: { name: 'Acme Corp' } // joined data
}

// Transformacja do formatu komponentu
const componentJob = {
  id: dbJob.id,
  title: dbJob.title,
  company: dbJob.companies.name,
  location: dbJob.location,
  postedDays: dbJob.posted_days_ago,
  type: dbJob.employment_type,
  experience: dbJob.experience_level,
  salaryMin: dbJob.salary_min,
  salaryMax: dbJob.salary_max,
  description: dbJob.description,
  skills: dbJob.skills
}
```

## 🔧 **Użycie useJobs composable**

```typescript
// W komponencie Vue
import { useJobs } from '@/composables/useJobs'

export default {
  setup() {
    const { 
      jobs, 
      loading, 
      fetchJobs, 
      filterJobs, 
      searchJobs 
    } = useJobs()

    // Pobierz wszystkie oferty
    async function loadJobs() {
      const result = await fetchJobs()
      if (result.success) {
        console.log('Załadowano oferty:', result.data)
      }
    }

    // Wyszukaj oferty
    async function search(term: string) {
      const result = await searchJobs(term)
      if (result.success) {
        console.log('Wyniki wyszukiwania:', result.data)
      }
    }

    return {
      jobs,
      loading,
      loadJobs,
      search
    }
  }
}
```

## 📝 **Migration Checklist**

### ✅ **Co zostało zachowane:**
- [x] Wszystkie pola z oryginalnego interfejsu `Job`
- [x] Logika filtrowania w komponencie
- [x] Struktura komponentów Vue
- [x] TypeScript interfaces
- [x] Wszystkie funkcje z JobsView.vue

### 🆕 **Co zostało dodane:**
- [x] Supabase integration
- [x] Relacyjna baza danych
- [x] Row Level Security (RLS)
- [x] UUID primary keys
- [x] Auto-calculated `posted_days_ago`
- [x] Extended job information (benefits, requirements, equity)
- [x] Company management
- [x] User profiles and applications
- [x] Job categories system

### 🔄 **Co wymaga aktualizacji:**

1. **JobsView.vue** - zamienić hardkodowane dane na `useJobs()` composable
2. **JobCard.vue** - zaktualizować dla UUID ids
3. **Dodać .env** z kluczami Supabase
4. **Wykonać migration SQL** w Supabase dashboard

## 🚀 **Następne kroki implementacji:**

1. **Skonfiguruj bazę danych** (DATABASE_SETUP.md)
2. **Zaktualizuj JobsView.vue** - zastąp mock dane wywołaniami do `useJobs()`
3. **Przetestuj integrację** z prawdziwymi danymi
4. **Dodaj funkcjonalności**:
   - Zapisywanie ofert
   - Aplikowanie na oferty  
   - Filtrowanie po kategoriach
   - Zarządzanie firmami

## 🔍 **Debugging**

Jeśli wystąpią problemy:

1. **Sprawdź konsole** - błędy SQL będą widoczne
2. **Sprawdź RLS policies** - czy użytkownik ma dostęp
3. **Sprawdź .env** - czy klucze Supabase są poprawne
4. **Sprawdź network tab** - czy zapytania do Supabase są wysyłane 