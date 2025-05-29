# 🔧 Naprawa błędu "Database error saving new user"

## Problem
Błąd `{"code":"unexpected_failure","message":"Database error saving new user"}` oznacza, że Supabase nie może utworzyć profilu użytkownika po rejestracji.

## Przyczyna
Brakuje triggera w bazie danych, który automatycznie tworzy rekord w tabeli `user_profiles` po rejestracji użytkownika w `auth.users`.

## Rozwiązanie - WYKONAJ TE KROKI:

### 1. **Zaloguj się do Supabase Dashboard**
- Przejdź do [supabase.com](https://supabase.com)
- Otwórz swój projekt

### 2. **Otwórz SQL Editor**
- W lewym menu kliknij **SQL Editor**
- Kliknij **New Query**

### 3. **Wykonaj schemat główny (jeśli jeszcze nie wykonałeś)**
```sql
-- Skopiuj całą zawartość pliku database/schema.sql i wykonaj
```

### 4. **WYKONAJ TRIGGER (NAJWAŻNIEJSZE!)**
Skopiuj i wykonaj zawartość pliku `database/auth_trigger.sql`:

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

### 5. **Weryfikacja**
Po wykonaniu SQL sprawdź czy trigger działa:

```sql
-- Sprawdź czy funkcja istnieje
SELECT routine_name, routine_type 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name = 'handle_new_user';

-- Sprawdź czy trigger istnieje
SELECT trigger_name, event_manipulation, event_object_table 
FROM information_schema.triggers 
WHERE trigger_name = 'on_auth_user_created';
```

### 6. **Testowanie**
- Wróć do aplikacji
- Spróbuj zarejestrować nowego użytkownika
- Błąd powinien zniknąć!

## Co robi ten trigger?
1. Gdy nowy użytkownik rejestruje się przez Supabase Auth
2. Trigger automatycznie tworzy odpowiadający mu rekord w tabeli `user_profiles`
3. Kopiuje `id`, `email` i timestampy z `auth.users`

## Sprawdzenie czy to działa
Po rejestracji użytkownika wykonaj:

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

Wszystkie użytkownicy powinni mieć odpowiadające im profile! 