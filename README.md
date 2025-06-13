# Jobly

## 📋 O Projekcie

Jobly to nowoczesna platforma do zarządzania ofertami pracy, która łączy pracodawców z potencjalnymi pracownikami. Aplikacja oferuje intuicyjny interfejs użytkownika, zaawansowane funkcje wyszukiwania.

### 🎯 Główne Cele Projektu

- Stworzenie przyjaznej dla użytkownika platformy do przeglądania i aplikowania na oferty pracy
- Zapewnienie pracodawcom narzędzi do efektywnego zarządzania ofertami
- Zapewnienie bezpiecznej i skalowalnej architektury

## 🚀 Funkcjonalności

### Dla Kandydatów
- Przeglądanie ofert pracy z zaawansowanymi filtrami
- Tworzenie i zarządzanie profilem zawodowym
- Zapisywanie ulubionych ofert

### Dla Pracodawców
- Publikowanie i zarządzanie ofertami pracy
- Przeglądanie i filtrowanie aplikacji
- Zarządzanie profilem firmy

## 🛠️ Stos Technologiczny

### Frontend
- **Vue 3** - Framework JavaScript do budowania interfejsów użytkownika
- **TypeScript** - Typowany JavaScript dla lepszej jakości kodu
- **Vite** - Nowoczesny bundler i serwer deweloperski
- **Pinia** - Zarządzanie stanem aplikacji
- **Vue Router** - Routing i nawigacja

### Backend (Supabase)
- **PostgreSQL** - Baza danych
- **Authentication** - System autoryzacji i autentykacji
- **Storage** - Przechowywanie plików

### Narzędzia Deweloperskie
- **ESLint** - Linter JavaScript/TypeScript
- **Prettier** - Formatowanie kodu
- **Vitest** - Framework testowy
- **Git** - System kontroli wersji

## 🏗️ Architektura Aplikacji

### Struktura Projektu
```
src/
├── assets/          # Statyczne zasoby (obrazy, style)
├── components/      # Komponenty wielokrotnego użytku
├── composables/     # Kompozycje Vue (hooks)
├── layouts/         # Układy stron
├── pages/          # Komponenty stron
├── router/         # Konfiguracja routingu
├── stores/         # Store Pinia
├── types/          # Definicje TypeScript
└── utils/          # Funkcje pomocnicze
```

### Wzorce Projektowe
- Composition API dla lepszej organizacji kodu
- Komponenty wielokrotnego użytku
- Custom composables dla logiki biznesowej
- Store pattern dla zarządzania stanem
- Lazy loading dla optymalizacji wydajności

## 🏗️ Konfiguracja Projektu

1. Sklonuj repozytorium
2. Zainstaluj zależności:
```sh
npm install
```

3. Utwórz plik `.env` na podstawie `.env.example` i wypełnij dane dostępowe do Supabase:
```env
VITE_SUPABASE_URL=twoj_url_supabase
VITE_SUPABASE_ANON_KEY=twoj_klucz_anonimowy
```

4. Uruchom serwer deweloperski:
```sh
npm run dev
```

## 📝 Dostępne Skrypty

- `npm run dev` - Uruchom serwer deweloperski
- `npm run build` - Zbuduj wersję produkcyjną
- `npm run preview` - Podgląd wersji produkcyjnej
- `npm run test:unit` - Uruchom testy jednostkowe
- `npm run lint` - Sprawdź kod
- `npm run format` - Sformatuj kod za pomocą Prettier