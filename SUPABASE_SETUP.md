# Supabase Implementation

This project now includes Supabase integration for authentication and database operations.

## Setup

### 1. Environment Variables

Create a `.env` file in the project root with your Supabase credentials:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 2. Supabase Project Setup

1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Get your project URL and anon key from Settings → API
4. Add these to your `.env` file

## Usage

### Authentication Store (Pinia)

```typescript
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

// Sign up
await authStore.signUp('email@example.com', 'password123')

// Sign in
await authStore.signIn('email@example.com', 'password123')

// Sign out
await authStore.signOut()

// Check auth state
console.log(authStore.isAuthenticated)
console.log(authStore.user)
```

### Composables

#### useSupabase

```typescript
import { useSupabase } from '@/composables/useSupabase'

const { user, session, loading, error, signIn, signOut } = useSupabase()
```

#### useDatabase

```typescript
import { useDatabase } from '@/composables/useDatabase'

const { data, loading, error, select, insert, update, remove } = useDatabase()

// Select data
await select('jobs', {
	columns: 'id, title, company',
	filters: { status: 'active' },
	orderBy: { column: 'created_at', ascending: false },
	limit: 10
})

// Insert data
await insert('jobs', { title: 'Developer', company: 'Tech Corp' })

// Update data
await update('jobs', { title: 'Senior Developer' }, { id: '123' })

// Delete data
await remove('jobs', { id: '123' })
```

## Files Structure

```
src/
├── lib/
│   └── supabase.ts          # Supabase client configuration
├── stores/
│   └── auth.ts              # Pinia auth store
├── composables/
│   ├── useSupabase.ts       # Auth composable
│   └── useDatabase.ts       # Database operations composable
└── types/
    └── supabase.ts          # TypeScript type definitions
```

## Features

- ✅ Authentication (sign up, sign in, sign out, password reset)
- ✅ Reactive auth state management
- ✅ Database CRUD operations
- ✅ TypeScript support
- ✅ Error handling
- ✅ Loading states
- 🔄 Real-time subscriptions (basic implementation)

## Next Steps

1. Set up your Supabase database tables
2. Configure Row Level Security (RLS) policies
3. Extend the types in `src/types/supabase.ts` for your specific data models
4. Create specific composables for your entities (jobs, companies, etc.)
5. Implement real-time features as needed 