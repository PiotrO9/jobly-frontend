# 🔧 Fix "Database error saving new user" Error

## Problem
The error `{"code":"unexpected_failure","message":"Database error saving new user"}` means that Supabase cannot create a user profile after registration.

## Cause
Missing trigger in the database that automatically creates a record in the `user_profiles` table after a user registers in `auth.users`.

## Solution - FOLLOW THESE STEPS:

### 1. **Log in to Supabase Dashboard**
- Go to [supabase.com](https://supabase.com)
- Open your project

### 2. **Open SQL Editor**
- In the left menu, click **SQL Editor**
- Click **New Query**

### 3. **Execute main schema (if not done yet)**
```sql
-- Copy the entire contents of database/schema.sql and execute
```

### 4. **EXECUTE TRIGGER (MOST IMPORTANT!)**
Copy and execute the contents of the `database/auth_trigger.sql` file:

```sql
-- Function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.created_at,
    NEW.updated_at
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Grant permissions
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO postgres, anon, authenticated, service_role;
```

### 5. **Verification**
After executing the SQL, check if the trigger works:

```sql
-- Check if function exists
SELECT routine_name, routine_type 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name = 'handle_new_user';

-- Check if trigger exists
SELECT trigger_name, event_manipulation, event_object_table 
FROM information_schema.triggers 
WHERE trigger_name = 'on_auth_user_created';
```

### 6. **Testing**
- Return to the application
- Try to register a new user
- The error should be gone!

## What does this trigger do?
1. When a new user registers through Supabase Auth
2. The trigger automatically creates a corresponding record in the `user_profiles` table
3. Copies `id`, `email` and timestamps from `auth.users`

## Check if it works
After user registration, execute:

```sql
SELECT 
  au.email,
  up.id,
  up.email,
  up.created_at
FROM auth.users au
LEFT JOIN user_profiles up ON au.id = up.id
ORDER BY au.created_at DESC
LIMIT 5;
```

All users should have corresponding profiles! 