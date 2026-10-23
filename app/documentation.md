# Data Layer Documentation

## Overview

The data layer resides under `lib/core/data/` and is responsible for fetching raw weather data from the OpenWeatherMap API, deserializing JSON responses into domain entities, and surfacing a clean repository interface to the rest of the application.

```
lib/core/data/
├── client/
│   └── api_client.dart          # HTTP client wrapper
├── constants/
│   └── data_constants.dart       # API base URL & app ID
├── dto/
│   ├── forecast_dto.dart         # Forecast JSON → Weather entity
│   └── weather_dto.dart          # Current weather JSON → Weather entity
├── exceptions/
│   ├── api_client_exception.dart # Thin wrapper around BaseException
│   └── base_exception.dart       # Base exception with original error
└── repositories/
    └── open_weather_repository.dart # Concrete repository implementation
```

---

## Architecture

The data layer follows a **Clean Architecture** separation of concerns:

| Layer | Responsibility |
|---|---|
| **Domain** (`lib/core/domain/`) | Business entities, repository interfaces, use-case logic. No dependencies on data or presentation. |
| **Data** (`lib/core/data/`) | API calls, JSON deserialization, exception handling. Depends on domain for entity types. |

The repository interface (`IWeatherRepository`) lives in the **domain** layer so the domain remains independent of any data-fetching implementation. The concrete `OpenWeatherRepository` lives in the **data** layer and implements that interface.

---

## Components

### 1. `IWeatherRepository` (Domain Interface)

**Location:** `lib/core/domain/repositories/i_weather_repository.dart`

Defines the contract that all weather data sources must implement:

```dart
abstract class IWeatherRepository {
  Future<Weather> getWeather({required double lat, required double lon, required String unit});
  Future<List<Weather>> getForecast({required double lat, required double lon, required String unit});
}
```

- **`getWeather`** — Fetches current weather for a single coordinate.
- **`getForecast`** — Fetches a 5-day / 3-hour forecast for a single coordinate.

Both methods accept `lat`, `lon`, and `unit` (metric or imperial) as parameters. The interface returns domain `Weather` objects, decoupling the domain from any serialization logic.

---

### 2. `OpenWeatherRepository` (Concrete Implementation)

**Location:** `lib/core/data/repositories/open_weather_repository.dart`

The sole implementation of `IWeatherRepository`, registered with `@Injectable(as: IWeatherRepository)` for dependency injection via `get_it`.

**Methods:**

| Method | API Endpoint | Returns |
|---|---|---|
| `getWeather` | `/data/2.5/weather` | `Future<Weather>` — current weather |
| `getForecast` | `/data/2.5/forecast` | `Future<List<Weather>>` — forecast entries |

**Flow:**

1. Constructs an HTTP GET request with `lat`, `lon`, `units`, and `appid` query parameters.
2. Calls `ApiClient.get()` to perform the HTTP request.
3. On success, passes the raw JSON `Map<String, dynamic>` to the appropriate DTO's `toEntity()` method.
4. On failure, wraps the original exception in an `ApiClientException` and re-throws.

**Error handling:** All API errors are caught and re-thrown as `ApiClientException`, preserving the original exception via `originalException`. This allows callers to inspect the root cause while exposing a consistent error type.

---

### 3. `ApiClient` (HTTP Client Wrapper)

**Location:** `lib/core/data/client/api_client.dart`

A thin HTTP client that:

- Builds a `Uri` from a base URL (defaults to `api.openweathermap.org`), an endpoint path, and query parameters.
- Logs the request URL, response status, and response body in debug mode (`kDebugMode`).
- Decodes the response body as JSON (`jsonDecode`).
- Returns `Map<String, dynamic>` on a 200 response.
- Throws `ApiClientException` on non-200 status codes or network errors.

---

### 4. DTOs (Data Transfer Objects)

DTOs bridge the gap between raw JSON from the API and domain `Weather` entities.

#### `WeatherDto`

**Location:** `lib/core/data/dto/weather_dto.dart`

Converts a single weather JSON object (e.g., from the current-weather endpoint) into a `Weather` domain entity. Key mappings:

| JSON Key | Entity Field |
|---|---|
| `main.temp` | `temp` |
| `main.temp_min` | `tempMin` |
| `main.temp_max` | `tempMax` |
| `main.feels_like` | `feelsLike` |
| `main.pressure` | `pressure` |
| `main.humidity` | `humidity` |
| `wind.speed` | `windSpeed` |
| `wind.deg` | `windDegree` |
| `clouds.all` | `cloudCoverage` |
| `visibility` | `visibility` |
| `weather[0].main` | `principle` |
| `weather[0].description` | `description` |
| `weather[0].icon` | `icon` |
| `dt` + `timezone` | `dateTime` (computed) |

The `dateTime` is computed as `(dt + timezone) * 1000` milliseconds since epoch, converting the API's Unix timestamp into a `DateTime`.

#### `ForecastDto`

**Location:** `lib/core/data/dto/forecast_dto.dart`

Extracts the `list` array from the forecast JSON response and maps each entry through `WeatherDto.toEntity()`, returning a `List<Weather>`.

---

### 5. Exceptions

#### `BaseException`

**Location:** `lib/core/data/exceptions/base_exception.dart`

Base exception class that stores the original exception (`originalException`) and delegates `toString()` to it. This preserves stack trace information for debugging while providing a consistent error type for callers.

#### `ApiClientException`

**Location:** `lib/core/data/exceptions/api_client_exception.dart`

Thin subclass of `BaseException` used specifically for HTTP/API failures.

---

### 6. Constants

**Location:** `lib/core/data/constants/data_constants.dart`

Holds application-wide data configuration:

| Constant | Value |
|---|---|
| `baseApiUrl` | `api.openweathermap.org` |
| `appId` | OpenWeatherMap API key |

---

---

## Domain Layer

The domain layer resides under `lib/core/domain/` and represents the core business logic of the application. It contains **entities**, **enums**, **repository interfaces**, **state/event classes**, and **cubits** (use-case logic). The domain layer has zero dependencies on the data or presentation layers — it defines *what* the app does, not *how* it does it.

```
lib/core/domain/
├── entities/
│   ├── entity.dart          # Abstract base with uuid + Equatable
│   ├── coordinate.dart      # Latitude / longitude pair
│   ├── location.dart        # City-type wrapper with weather + forecast
│   └── weather.dart         # Full weather record (temp, wind, etc.)
├── enums/
│   ├── city_type.dart       # Hardcoded UK cities with coordinates
│   ├── map_tile_type.dart   # Map overlay types (clouds, temp, etc.)
│   └── unit_type.dart       # Metric (°C) vs Imperial (°F)
├── logic/
│   ├── map/
│   │   ├── map_cubit.dart   # Map state management
│   │   └── map_state.dart   # Map state classes
│   └── weather/
│       ├── weather_cubit.dart   # Weather data use case
│       └── weather_state.dart   # Weather state classes
├── observer/
│   └── app_bloc_observer.dart  # Global bloc/lifecycle observer
└── repositories/
    └── i_weather_repository.dart  # Weather data contract
```

### 1. Entities

Entities are plain data objects that model real-world concepts. Every entity extends `Entity`, which provides a `uuid` and `Equatable` equality semantics.

#### `Entity` (Abstract Base)

**Location:** `lib/core/domain/entities/entity.dart`

```dart
abstract class Entity implements Equatable {
  final String uuid;
  @override
  List<Object?> get props => [this.uuid];
}
```

All entities inherit `uuid` for identity and `Equatable` for value-based equality (useful in state comparisons).

#### `Weather`

**Location:** `lib/core/domain/entities/weather.dart`

Represents a single weather observation with the following fields:

| Field | Type | Description |
|---|---|---|
| `temp` | `double` | Current temperature |
| `tempMin` | `double` | Minimum temperature |
| `tempMax` | `double` | Maximum temperature |
| `feelsLike` | `double` | Feels-like temperature |
| `pressure` | `int` | Atmospheric pressure (hPa) |
| `humidity` | `int` | Humidity percentage |
| `windSpeed` | `double` | Wind speed |
| `windDegree` | `int` | Wind direction in degrees |
| `cloudCoverage` | `int` | Cloud coverage percentage |
| `visibility` | `int` | Visibility in meters |
| `principle` | `String` | Main weather condition (e.g., "Clear") |
| `description` | `String` | Detailed description (e.g., "clear sky") |
| `icon` | `String` | Weather icon code |
| `unitType` | `UnitType` | Temperature unit (metric/imperial) |
| `dateTime` | `DateTime` | Time of observation |

Includes a `copyWith` method for creating modified copies immutably.

#### `Location`

**Location:** `lib/core/domain/entities/location.dart`

Wraps a single city's weather data:

| Field | Type | Description |
|---|---|---|
| `cityType` | `CityType` | Enum identifying the city |
| `weather` | `Weather` | Current weather observation |
| `forecast` | `List<Weather>` | 5-day / 3-hour forecast |

#### `Coordinate`

**Location:** `lib/core/domain/entities/coordinate.dart`

Simple value object holding `lat` and `lon` doubles, used throughout the app to identify geographic positions.

---

### 2. Enums

Enums carry business rules and presentation-facing metadata. Each enum has an extension that provides derived values.

#### `CityType`

**Location:** `lib/core/domain/enums/city_type.dart`

Defines five hardcoded UK cities, each with embedded GPS coordinates and localized display titles:

| Enum Value | Coordinates |
|---|---|
| `norwich` | 52.6293°N, 1.2979°E |
| `london` | 51.5072°N, 0.1276°E |
| `glasgow` | 55.8617°N, 4.2583°W |
| `cardiff` | 51.4849°N, 3.1763°W |
| `cambridge` | 52.2048°N, 0.1197°E |

The `CityTypeExtension` provides:
- **`coordinate`** — Returns the `Coordinate` for each city.
- **`title()`** — Returns a localized display name via `AppLocalizations`.

#### `MapTileType`

**Location:** `lib/core/domain/enums/map_tile_type.dart`

Defines map overlay types for Google Maps:

| Enum Value | API Tile Name |
|---|---|
| `clouds` | `clouds_new` |
| `temperature` | `temp_new` |
| `precipitation` | `precipitation_new` |
| `wind` | `wind_new` |
| `pressure` | `pressure_new` |

The `MapTileTypeExtension` provides:
- **`apiName`** — The tile layer name expected by the Google Maps API.
- **`title()`** — Localized display name.

#### `UnitType`

**Location:** `lib/core/domain/enums/unit_type.dart`

| Enum Value | Symbol |
|---|---|
| `metric` | ° (Celsius) |
| `imperial` | F (Fahrenheit) |

The `UnitTypeExtension` provides:
- **`symbol`** — The temperature unit symbol for display.

---

### 3. Repository Interface

See the [Data Layer — `IWeatherRepository`](#1-iweatherrepository-domain-interface) section above. This interface is defined in the domain layer so that the cubits (which live in the domain layer) can depend on it without depending on any data-fetching implementation.

---

### 4. Cubits (Use-Case Logic)

Cubits are Flutter's lightweight state management primitives (from the `bloc` package). Each cubit extends `Cubit<State>` and exposes methods that transition the app's state. Both cubits are registered with `@injectable` for dependency injection.

#### `WeatherCubit`

**Location:** `lib/core/domain/logic/weather/weather_cubit.dart`

**Purpose:** Orchestrates fetching and managing weather data for all five cities.

**Dependencies:**
- `IWeatherRepository` — Injected via constructor; fetches current weather and forecasts.

**Internal State:**
| Field | Type | Default | Description |
|---|---|---|---|
| `_unitType` | `UnitType` | `metric` | Current temperature unit |
| `_locations` | `Set<Location>` | `{}` | Cache of all city weather data |

**Public Methods:**

| Method | Signature | Description |
|---|---|---|
| `loadAllWeather` | `Future<void> loadAllWeather()` | Fetches current weather and 5-day forecasts for all five cities. Iterates over `CityType.values`, calls the repository for each, and emits `WeatherStateSuccess` with the full `List<Location>`. Individual city failures are silently ignored so one bad API response doesn't break all cities. |
| `toggleUnitType` | `void toggleUnitType()` | Switches between metric and imperial units. Re-emits the cached locations with the updated `unitType` via `copyWith`. Falls back to metric on error. |

**Private Methods:**

| Method | Signature | Description |
|---|---|---|
| `_loadWeather` | `Future<Weather> _loadWeather({required CityType})` | Calls the repository for a single city's current weather, applies `copyWith(unitType: _unitType)`, and re-throws on failure. |
| `_loadForecast` | `Future<List<Weather>> _loadForecast({required CityType})` | Calls the repository for a single city's forecast, applies `copyWith(unitType: _unitType)` to each entry, and re-throws on failure. |

**State Transitions:**

```
WeatherStateInitial
  │
  ├─► WeatherStateLoading (future)
  │
  ├─► WeatherStateSuccess(locations, unitType)
  │
  └─► WeatherStateFailure(unitType)
```

#### `MapCubit`

**Location:** `lib/core/domain/logic/map/map_cubit.dart`

**Purpose:** Manages the state of the Google Map view — coordinate, map style (normal/satellite), and tile overlay (clouds, temperature, precipitation, wind, pressure).

**Internal State:**
| Field | Type | Default | Description |
|---|---|---|---|
| `_coordinate` | `Coordinate` | (unset) | Currently displayed location |
| `_mapType` | `MapType` | `normal` | Map style (normal or satellite) |
| `_mapTileType` | `MapTileType` | `temperature` | Active tile overlay |

**Public Methods:**

| Method | Signature | Description |
|---|---|---|
| `loadMap` | `void loadMap({required Coordinate})` | Sets the displayed coordinate and emits `MapStateSuccess`. |
| `toggleMapType` | `void toggleMapType()` | Toggles between `normal` and `satellite` map styles and emits the updated state. |
| `changeMapTileType` | `void changeMapTileType({required MapTileType})` | Updates the tile overlay (e.g., clouds → temperature) and emits the updated state. |

**State Transitions:**

```
MapStateInitial
  │
  ├─► MapStateSuccess(coordinate, mapType, mapTileType)
  │
  ├─► MapStateError()
  │
  └─► MapStateFailure()
```

---

### 5. State Classes

State classes are immutable snapshots of the cubit's state. They extend `Equatable` for value-based equality, enabling the cubit to detect meaningful changes.

#### `WeatherState`

**Location:** `lib/core/domain/logic/weather/weather_state.dart`

Base class with a `unitType` field. All weather states inherit from it:

| State | Fields | Meaning |
|---|---|---|
| `WeatherStateInitial` | `unitType` | Initial state before any data is loaded |
| `WeatherStateLoading` | `unitType` | Data is being fetched (future state) |
| `WeatherStateSuccess` | `unitType`, `locations` | Data loaded successfully with `List<Location>` |
| `WeatherStateFailure` | `unitType` | A failure occurred |

#### `MapState`

**Location:** `lib/core/domain/logic/map/map_state.dart`

Abstract base class. All map states inherit from it:

| State | Fields | Meaning |
|---|---|---|
| `MapStateInitial` | (none) | Initial state before map is loaded |
| `MapStateSuccess` | `coordinate`, `mapType`, `mapTileType` | Map loaded with full configuration |
| `MapStateError` | (none) | An error occurred during map loading |
| `MapStateFailure` | (none) | A failure occurred (distinct from transient errors) |

---

### 6. Bloc Observer

**Location:** `lib/core/domain/observer/app_bloc_observer.dart`

A global `BlocObserver` registered to monitor all cubit/bloc lifecycle events:

| Lifecycle Method | Behavior |
|---|---|
| `onEvent` | Prints event names (debug only) |
| `onTransition` | No-op |
| `onChange` | Prints the next state |
| `onError` | Prints errors (debug only) |
| `onCreate` | No-op |
| `onClose` | No-op |
| `onDone` | No-op (required by bloc v9.x) |

Registered with `@injectable` for dependency injection.

---

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│  Domain Layer                                                         │
│                                                                     │
│  ┌──────────────────┐    ┌──────────────────┐                      │
│  │  WeatherCubit    │    │ IWeatherRepository│                      │
│  │  (use case)      │◄───│  (interface)     │                      │
│  └────────┬─────────┘    └───────┬──────────┘                      │
│           │                       │  (implements)                   │
└───────────┼───────────────────────┼─────────────────────────────────┘
            │                       │
            ▼                       ▼
┌─────────────────────────────────────────────────────────────────────┐
│  Data Layer                                                         │
│                                                                     │
│  ┌──────────────────────────────┐                                  │
│  │  OpenWeatherRepository       │                                  │
│  │  (concrete impl.)            │                                  │
│  └──────────┬───────────────────┘                                  │
│             │                                                       │
│             ▼                                                       │
│  ┌──────────────────┐    ┌──────────────────┐                     │
│  │  ApiClient       │    │  WeatherDto      │                     │
│  │  (HTTP GET)      │───►│  (JSON → Entity) │                     │
│  └──────────────────┘    └──────────────────┘                     │
│                                                ┌──────────────────┐│
│                                                │  ForecastDto     ││
│                                                │  (list mapping)  ││
│                                                └──────────────────┘│
└─────────────────────────────────────────────────────────────────────┘
```

1. **`WeatherCubit`** (domain use case) calls `IWeatherRepository.getWeather()` or `getForecast()`.
2. **`OpenWeatherRepository`** (data layer) constructs the API URL, calls `ApiClient.get()`.
3. **`ApiClient`** performs the HTTP GET, logs debug info, and returns decoded JSON.
4. **`WeatherDto`** or **`ForecastDto`** transforms the raw JSON into `Weather` domain entities.
5. Entities flow back up through the repository interface to the cubit, keeping the domain clean of data-layer concerns.

---

## Presentation Layer

The presentation layer resides under `lib/core/presentation/` and is responsible for **rendering UI**, **handling user interaction**, and **navigating between screens**. It depends on the domain layer (for entities, enums, cubits, and repository interfaces) but never depends on the data layer — the domain layer's repository interface abstracts away all API concerns.

```
lib/core/presentation/
├── components/
│   ├── app_base_button.dart  # Reusable button with tooltip, hover, cursor
│   └── app_screen.dart       # Screen shell (safe area, back handling, orientation)
├── constants/
│   └── presentation_constants.dart  # API image / tile URLs
├── delegates/
│   ├── app_delegate.dart        # App root (providers, theme, navigator)
│   └── app_routes_delegate.dart # Route definitions & navigation builder
├── extensions/
│   └── string_extensions.dart   # String.capitalise extension
├── fragments/
│   ├── bottom_sheet.dart        # Bottom sheet helper + widget
│   ├── location_listing_item.dart  # City weather card
│   ├── map.dart                 # Google Map with tile overlays
│   └── nav_bar.dart             # Top navigation bar with back button
├── localizations/
│   └── app_localizations.dart   # i18n strings & delegate
├── screens/
│   ├── main_screen.dart         # Home: city list (weather + forecast)
│   ├── detail_screen.dart       # City detail: temp, forecast, stats, map
│   └── sync_screen.dart         # Loading / fallback screen
└── styles/
    ├── app_text_styles.dart     # 8 typography presets
    ├── app_colors_scheme_base.dart  # Abstract color palette (22 colors)
    ├── app_colors_scheme_light.dart # Light theme colors
    ├── app_colors_scheme_dark.dart  # Dark theme colors
    ├── app_colors_light.dart        # Light theme raw Color constants
    ├── app_colors_dark.dart         # Dark theme raw Color constants
    ├── app_colors_delegate.dart     # InheritedWidget for color access
    ├── app_border_radius.dart     # Border radius presets
    ├── app_box_shadow.dart        # Standard box shadow
    ├── app_break_points.dart      # Responsive breakpoints
    ├── app_gradients.dart         # Reusable gradient presets
    └── app_icons.dart           # Asset icon paths
```

---

### 1. Shared Styles

The styles folder provides a **design system** — a single source of truth for colors, typography, spacing, and visual effects. Every screen and fragment references these shared styles rather than hard-coding values, ensuring visual consistency and enabling theme switching (light/dark).

#### Color System

The color system is built on a **three-level hierarchy**:

```
AppColorsLight / AppColorsDark  (raw Color constants)
        │
        ▼
AppColorsSchemeBase              (abstract class: 22 named colors)
        │
        ├── AppColorsSchemeLight  (light theme instance)
        └── AppColorsSchemeDark   (dark theme instance)
        │
        ▼
AppColorsDelegate                (InheritedWidget: provides colors to subtree)
```

**How it works:**

1. **Raw color constants** (`AppColorsLight`, `AppColorsDark`) define the actual `Color` values for light and dark themes. The accent colors (aqua, seafoam, strawberry, peach, raspberry, grape, blueberry) are shared between themes; the neutral palette (dust, slate, mineral, carbon, coal, white, black) inverts between themes.

2. **`AppColorsSchemeBase`** is an abstract class with 22 named `Color` properties, organized into groups:
   - **Accent colors** (7): `aqua`, `seafoam`, `strawberry`, `peach`, `raspberry`, `grape`, `blueberry`
   - **Neutral colors** (5): `dust` (background), `slate` (borders), `mineral` (text secondary), `carbon` (text tertiary), `coal` (text primary)
   - **Transparent** (1): `transparent`
   - **White scale** (4): `white`, `white75`, `white50`, `white25`
   - **Black scale** (6): `black`, `black75`, `black50`, `black35`, `black25`, `black0`

3. **`AppColorsSchemeLight`** and **`AppColorsSchemeDark`** extend the base class, mapping the raw constants to the abstract properties.

4. **`AppColorsDelegate`** wraps the scheme in an `InheritedWidget`, making colors accessible from anywhere in the widget subtree:
   ```dart
   AppColorsDelegate.of(context).coal        // Primary text color
   AppColorsDelegate.of(context).white       // Background color
   AppColorsDelegate.of(context).aqua        // Accent color
   ```

**Usage:** Wrap a widget subtree with `AppColorsDelegate(appColorsScheme: AppColorsSchemeLight(), child: ...)`. All descendant widgets can then access colors via `AppColorsDelegate.of(context)`.

#### Typography System

**Location:** `lib/core/presentation/styles/app_text_styles.dart`

`AppTextStyles` extends `TextStyle` and provides **8 predefined text presets**, all using the `Outfit` font family. Each style accepts a `BuildContext` to resolve the current theme's text color (`coal`).

| Style | Weight | Size | Letter Spacing | Line Height | Use Case |
|---|---|---|---|---|---|
| `hero` | w800 (extra bold) | 34 | -0.5 | 1.15 | Large titles, hero temperatures |
| `headline` | w700 (bold) | 20 | 0.0 | 1.15 | Section headers, city names |
| `title` | w600 (semi-bold) | 16 | -0.3 | 1.15 | Card titles, nav bar text |
| `subtitle` | w600 (semi-bold) | 14 | -0.3 | 1.15 | Subtitles, labels |
| `excerpt` | w600 (semi-bold) | 14 | -0.15 | 1.25 | Short data values (forecast temps) |
| `paragraph` | w300 (light) | 14 | -0.15 | 1.25 | Body text, descriptions |
| `small` | w300 (light) | 12 | -0.3 | 1.15 | Small labels, timestamps |
| `label` | w600 (semi-bold) | 12 | 0.25 | 1.0 | Uppercase labels, buttons |

**Usage:**
```dart
Text('Hello', style: AppTextStyles.headline(context: context))
```

#### Border Radius

**Location:** `lib/core/presentation/styles/app_border_radius.dart`

Predefined `BorderRadius` presets:

| Preset | Radius | Use Case |
|---|---|---|
| `AppBorderRadius.normal(topLeft, topRight, bottomLeft, bottomRight)` | 10px (per-corner) | Cards, containers. Each corner can be independently enabled/disabled. |
| `AppBorderRadius.button()` | 20px (all) | Buttons, pill-shaped elements |
| `AppBorderRadius.small()` | 10px (all) | Small cards, chips |

#### Box Shadow

**Location:** `lib/core/presentation/styles/app_box_shadow.dart`

A single preset: `AppBoxShadow` — 2px blur radius, white color. Used for subtle elevation on cards.

#### Breakpoints

**Location:** `lib/core/presentation/styles/app_break_points.dart`

Responsive width breakpoints for adaptive layouts:

| Breakpoint | Width |
|---|---|
| `mobileSmall` | 320px |
| `mobileMedium` | 375px |
| `mobileLarge` | 414px |
| `tabletSmall` | 640px |
| `tabletMedium` | 768px |
| `tabletLarge` | 840px |
| `desktop` | 1024px |
| `desktopLarge` | 1280px |

**Usage:**
```dart
BoxConstraints(maxWidth: AppBreakpoints.tabletMedium.toDouble())
```

#### Gradients

**Location:** `lib/core/presentation/styles/app_gradients.dart`

Predefined `LinearGradient` presets, all top-to-bottom:

| Gradient | Colors | Use Case |
|---|---|---|
| `white` | white → white | Solid white fills |
| `transparentBlack35` | transparent → black 35% | Fading overlays |
| `transparentBlack50` | transparent → black 50% | Fading overlays |
| `black75Transparent` | black 75% → transparent | Fading overlays (bottom-up) |
| `mineralSlate` | mineral → slate | Header backgrounds |
| `dustSlate` | dust → slate | Content backgrounds |
| `transparent` | transparent → transparent | No gradient |

#### Icons

**Location:** `lib/core/presentation/styles/app_icons.dart`

String paths to asset images:

| Icon | Asset Path |
|---|---|
| `iconChevronUp` | `lib/assets/images/icon_chevron_up.png` |
| `iconChevronDown` | `lib/assets/images/icon_chevron_down.png` |
| `iconChevronBack` | `lib/assets/images/icon_chevron_back.png` |
| `iconChevronForward` | `lib/assets/images/icon_chevron_forward.png` |
| `iconClose` | `lib/assets/images/icon_close.png` |
| `iconMap` | `lib/assets/images/icon_map.png` |

---

### 2. Shared Components

Reusable building blocks used across multiple screens.

#### `AppBaseButton`

**Location:** `lib/core/presentation/components/app_base_button.dart`

A `StatefulWidget` that wraps any child widget with:
- **Tap handling** via `onTap` callback
- **Hover effects** via `onHoverIn` / `onHoverOut` callbacks
- **Optional tooltip** via `tooltip` parameter
- **Cursor styling** via `systemMouseCursor` (defaults to `click` when `onTap` is set, `defer` otherwise)

Internally uses `MouseRegion` + `GestureDetector` + optional `Tooltip`.

**Usage:**
```dart
AppBaseButton(
  onTap: () => print('tapped'),
  child: Text('Tap me'),
)
```

#### `AppScreen`

**Location:** `lib/core/presentation/components/app_screen.dart`

A `StatefulWidget` that provides a **screen shell** with:
- **Orientation control** via `preferredOrientations` (defaults to portrait)
- **Safe area** toggles for top (`topSafeArea`) and bottom (`bottomSafeArea`)
- **Back navigation control** via `systemBackEnabled` (when `false`, wraps content in `PopScope(canPop: false)`)
- **Inset handling** via `resizeToAvoidBottomInset`
- **Background color** via `backgroundColor`

Internally creates a `Scaffold` with configurable `SafeArea` and optional `PopScope`.

**Usage:**
```dart
AppScreen(
  systemBackEnabled: false,  // Disable back navigation
  topSafeArea: true,
  backgroundColor: AppColorsDelegate.of(context).dust,
  child: MyContent(),
)
```

---

### 3. Shared Fragments

Reusable UI fragments — larger than components but smaller than full screens.

#### `NavBar`

**Location:** `lib/core/presentation/fragments/nav_bar.dart`

A fixed-height top navigation bar with:
- Optional **back button** (`showBackButton: true`)
- **Title text** using `AppTextStyles.headline`
- **Safe area** handling (bottom: false to allow content behind status bar)

**Usage:**
```dart
NavBar(title: 'London', showBackButton: true)
```

#### `LocationListingItem`

**Location:** `lib/core/presentation/fragments/location_listing_item.dart`

A clickable card showing a city's weather summary:
- City name (localized via `CityTypeExtension.title`)
- Weather description (capitalized via `StringExtension.capitalise`)
- Temperature with unit symbol
- Weather icon from OpenWeatherMap API

Navigates to `DetailScreen` when tapped.

**Usage:**
```dart
LocationListingItem(location: location)
```

#### `Map`

**Location:** `lib/core/presentation/fragments/map.dart`

A `StatefulWidget` that renders a Google Map with:
- **Tile overlays** from OpenWeatherMap (clouds, temperature, precipitation, wind, pressure)
- **Map type toggle** (normal / satellite) via a floating button
- **Tile type selector** via a bottom sheet (taps the overlay label)
- **Cubit integration** via `BlocProvider.value` + `BlocBuilder<MapCubit, MapState>`

Uses a custom `_MapTileProvider` implementing `TileProvider` to fetch 256×256 tile images from OpenWeatherMap's tile API.

**Usage:**
```dart
Map(
  coordinate: CityType.london.coordinate,
  showControls: true,  // Show map type toggle button
)
```

#### `BottomSheetWidget`

**Location:** `lib/core/presentation/fragments/bottom_sheet.dart`

A styled bottom sheet widget with:
- **Title bar** with close button
- **Scrollable content area** (`Expanded` child)
- **Safe area** handling (top padding accounts for notch)
- **Maximum width** constrained to `tabletMedium` (768px)

**`showBottomSheetWidget<T>`** is a helper function that wraps `showModalBottomSheet` with pre-configured styling (semi-transparent black barrier, transparent background).

**Usage:**
```dart
await showBottomSheetWidget<String>(
  context: context,
  isBarrierDismissable: true,
  bottomSheet: (context) => BottomSheetWidget(
    title: 'Select tile type',
    child: ListView(/* ... */),
  ),
);
```

---

### 4. Screens

Full-screen views that compose shared components and fragments.

#### `MainScreen`

**Location:** `lib/core/presentation/screens/main_screen.dart`

The home screen displaying a scrollable list of all five cities.

**Structure:**
```
AppScreen
  └─ Column
       ├─ NavBar (app name)
       └─ BlocBuilder<WeatherCubit>
            ├─ WeatherStateSuccess → ListView<LocationListingItem>
            ├─ WeatherStateFailure → Error card + retry button
            └─ WeatherStateInitial/Loading → CircularProgressIndicator
```

**Features:**
- Listens to `WeatherCubit` state changes via `BlocBuilder`
- Displays city weather cards (temperature, description, icon)
- Shows error state with retry button on failure
- Shows loading indicator while fetching

#### `DetailScreen`

**Location:** `lib/core/presentation/screens/detail_screen.dart`

A city detail screen composed of four vertical sections:

```
AppScreen
  └─ Column
       ├─ NavBar (city name, back button)
       └─ ListView
            ├─ _renderCurrent()    → Temperature, icon, description
            ├─ _renderForecast()   → Horizontal scroll: day, time, icon, temp
            ├─ _renderWeatherDetails() → Feels like, highs/lows, pressure, humidity, visibility
            └─ _renderMap()        → Google Map with tile overlay
```

**Features:**
- Displays current temperature, weather icon, and description
- Horizontal scrolling 5-day / 3-hour forecast strip
- Detailed weather stats panel (feels like, pressure, humidity, visibility)
- Embedded Google Map with tile overlay

#### `SyncScreen`

**Location:** `lib/core/presentation/screens/sync_screen.dart`

A simple loading/fallback screen showing a centered progress indicator. Used as the default route for unmatched paths.

---

### 5. Routing

**Location:** `lib/core/presentation/delegates/app_routes_delegate.dart`

`AppRoutesDelegate` defines the app's navigation structure:

| Route | Path | Arguments | Screen |
|---|---|---|---|
| `main` | `/` | (none) | `MainScreen` |
| `detail` | `/detail` | `Location` | `DetailScreen` |
| (default) | (any) | (none) | `SyncScreen` |

**Navigation to detail:**
```dart
Navigator.of(context).pushNamed(
  AppRoutesDelegate.detail,
  arguments: location,  // Location object passed as arguments
)
```

**Route retrieval:**
```dart
Location location = ModalRoute.of(context)!.settings.arguments as Location;
```

---

### 6. App Delegate (Root)

**Location:** `lib/core/presentation/delegates/app_delegate.dart`

`AppDelegate` is the app's root widget, configured as a `StatefulWidget` with:

- **`MultiProvider`** providing:
  - `RouteObserver` (global route tracking)
  - `BlocProvider<WeatherCubit>` (lazy: false, calls `loadAllWeather()` on creation)
- **`MaterialApp`** with:
  - Localizations (English only)
  - Custom font (`Outfit`)
  - Blue-grey primary swatch
  - `AppColorsDelegate` wrapper via `builder` (applies light theme)
- **`Navigator`** with:
  - Custom route generation via `AppRoutesDelegate.getAppRoutes`
  - `RouteObserver` in observers list
  - Back navigation handling via `PopScope` (pops the navigator stack instead of exiting)

---

### 7. Localizations

**Location:** `lib/core/presentation/localizations/app_localizations.dart`

`AppLocalizations` provides all user-facing strings via `Intl.message()`. Supported locale: English (`en`).

**Categories of strings:**

| Category | Strings |
|---|---|
| App identity | `applicationName`, `companyName`, `copyrightText` |
| Cities | `cityTypeTitleNorwich`, `cityTypeTitleLondon`, `cityTypeTitleGlasgow`, `cityTypeTitleCardiff`, `cityTypeTitleCambridge` |
| Weather labels | `feelsLike`, `highsLows`, `pressure`, `humidity`, `visibility` |
| Map labels | `mapTileTypeClouds`, `mapTileTypeTemperature`, `mapTileTypePrecipitation`, `mapTileTypeWind`, `mapTileTypePressure` |
| Error handling | `errorTitle`, `errorDescription`, `retry` |

**Usage:**
```dart
AppLocalizations.of(context).applicationName
```

---

### 8. Extensions

**Location:** `lib/core/presentation/extensions/string_extensions.dart`

A single extension on `String`:

| Extension | Description |
|---|---|
| `capitalise` | Capitalizes the first character of the string (e.g., `"clear sky"` → `"Clear sky"`) |

**Usage:**
```dart
location.weather.description.capitalise  // "Clear sky"
```

---

### 9. Constants

**Location:** `lib/core/presentation/constants/presentation_constants.dart`

Static URL constants for external resources:

| Constant | Value |
|---|---|
| `openWeatherImageBaseUrl` | `https://openweathermap.org/img/wn/` |
| `openWeatherTileBaseUrl` | `https://tile.openweathermap.org/map/` |

**Usage:**
```dart
// Weather icon
'$openWeatherImageBaseUrl${weather.icon}@2x.png'

// Map tile
'$openWeatherTileBaseUrl${mapTileType.apiName}/$zoom/$x/$y.png?appid=$appId'
```

---

## How Shared Presentation Files Are Used

The presentation layer is organized around **reusability** — every style, component, and fragment is designed to be imported and composed across multiple screens. Here's the typical pattern:

### Accessing Shared Styles

```dart
// 1. Colors — via InheritedWidget
AppColorsDelegate.of(context).coal       // Text color
AppColorsDelegate.of(context).white      // Background
AppColorsDelegate.of(context).aqua       // Accent

// 2. Typography — via factory constructors
AppTextStyles.hero(context: context)
AppTextStyles.headline(context: context)
AppTextStyles.title(context: context)
AppTextStyles.subtitle(context: context)
AppTextStyles.excerpt(context: context)
AppTextStyles.paragraph(context: context)
AppTextStyles.small(context: context)
AppTextStyles.label(context: context)

// 3. Border radius
AppBorderRadius.normal(topLeft: true, bottomRight: false)
AppBorderRadius.button()
AppBorderRadius.small()

// 4. Breakpoints
AppBreakpoints.tabletMedium  // 768

// 5. Gradients
AppGradients.mineralSlate
AppGradients.dustSlate
```

### Composing Shared Components

```dart
// Screen shell with back navigation disabled
AppScreen(
  systemBackEnabled: false,
  child: Column(children: [
    // Top bar
    NavBar(title: 'London', showBackButton: true),
    // Content
    Expanded(child: /* ... */),
  ]),
)

// Interactive button wrapping any widget
AppBaseButton(
  onTap: () => Navigator.of(context).pop(),
  child: Text('Back'),
)

// Clickable weather card
LocationListingItem(location: location)

// Bottom sheet for selections
await showBottomSheetWidget<String>(
  context: context,
  bottomSheet: (ctx) => BottomSheetWidget(
    title: 'Tile Type',
    child: ListView(/* ... */),
  ),
)

// Google map with tile overlays
Map(
  coordinate: CityType.london.coordinate,
  showControls: true,
)
```

### Typical Screen Composition Pattern

```
AppDelegate (root)
  └─ MaterialApp
       └─ AppColorsDelegate (theme wrapper)
            └─ Navigator
                 ├─ MainScreen
                 │    └─ AppScreen
                 │         ├─ NavBar
                 │         └─ BlocBuilder<WeatherCubit>
                 │              └─ ListView<LocationListingItem>
                 │
                 └─ DetailScreen
                      └─ AppScreen
                           ├─ NavBar
                           └─ ListView
                                ├─ _renderCurrent()
                                ├─ _renderForecast()
                                ├─ _renderWeatherDetails()
                                └─ Map
```

This layered composition ensures that:
- **Styles** are centralized — change a color or font once, it updates everywhere.
- **Components** (`AppBaseButton`, `AppScreen`) are reusable across all screens.
- **Fragments** (`NavBar`, `LocationListingItem`, `Map`, `BottomSheetWidget`) are composable building blocks.
- **Screens** are thin — they compose fragments and wire up cubits, keeping UI logic clear.
